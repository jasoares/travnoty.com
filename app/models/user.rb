class User < ActiveRecord::Base
  include BCrypt
  include Extensions::Authenticatable
  include Extensions::Confirmable
  include Extensions::Recoverable

  attr_accessible :email, :name, :username, :password,
    :last_sign_in_at, :sign_in_count

  validates :username, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :password, presence: { :on => :create }, confirmation: true
  validates :password, length: { :within => 8..128, :allow_blank => true }
  validates :email, presence: true, email_format: true
  validates :email, uniqueness: { case_sensitive: false, message: 'is already associated to an account' }

end
