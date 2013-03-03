class User < ActiveRecord::Base
  include BCrypt

  has_many :emails
  attr_accessible :email, :name, :username, :password, :password_confirmation,
    :last_sign_in_at, :sign_in_count

  attr_accessor :password

  before_save :encrypt_password

  validates :username, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :password, presence: { :on => :create }, confirmation: true, length: { :within => 8..128, :on => :create}
  validates :emails, presence: true, associated: true

  def email
    emails.first.address
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  class << self

    def authenticate(email_or_username, password)
      email = Email.where(address: email_or_username).first
      user = email.try(:user)
      user ||= User.where(username: email_or_username).first
      if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
        user
      else
        nil
      end
    end

  end
end
