class User < ActiveRecord::Base
  include BCrypt

  has_many :emails
  attr_accessible :email, :name, :username, :password, :password_confirmation,
    :last_sign_in_at, :sign_in_count

  attr_accessor :password

  before_save :encrypt_password

  validates :username, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :password, presence: { :on => :create }, confirmation: true
  validates :password, length: { :within => 8..128, :allow_blank => true }
  validates :emails, presence: true, associated_bubbling: true

  def email
    Email.where(user_id: self, main_address: true).first.address
  end

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

  class << self

    def authenticate(who, password)
      email = Email.where(address: who).first
      user = email.try(:user)
      user ||= User.where(username: who).first
      if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
        user
      else
        nil
      end
    end

  end
end
