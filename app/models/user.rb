class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :token_authenticatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  # need this at least until the pull request on plataformatec/devise is accepted
  validates_presence_of :password_confirmation, :if => :password_required?
end
