class User < ActiveRecord::Base
  include BCrypt
  include Extensions::Confirmable

  attr_accessible :email, :name, :username, :password, :password_confirmation,
    :last_sign_in_at, :sign_in_count

  attr_accessor :password

  before_save   :encrypt_password
  before_create :generate_confirmation_token
  after_create  :send_confirmation_instructions

  validates :username, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :password, presence: { :on => :create }, confirmation: true
  validates :password, length: { :within => 8..128, :allow_blank => true }
  validates :email, presence: true, email_format: true
  validates :email, uniqueness: { case_sensitive: false, message: 'is already associated to an account' }

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def change_password(params)
    if self.update_attributes(params)
      self.reset_token_sent_at = nil
      self.reset_password_token = nil
      self.save!
    end
  end

  def send_password_reset
    generate_token(:reset_password_token)
    self.reset_token_sent_at = DateTime.now.utc
    save(validate: false)
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64(15)
      break unless User.exists?(column => self[column])
    end
  end

protected

  def send_confirmation_instructions
    UserMailer.email_confirmation(self).deliver
  end

  def resend_confirmation_instructions
    send_confirmation_instructions if confirmation_pending?
  end

  class << self

    def authenticate(handle, password)
      user = User.where('users.email = ? OR users.username = ?', handle, handle).first
      if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
        user
      else
        nil
      end
    end

  end
end
