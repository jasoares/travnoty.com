class Admin < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :timeoutable, :lockable, :validatable

  attr_accessible :email, :password, :password_confirmation

  # need this at least until the pull request on plataformatec/devise is accepted
  validates_presence_of :password_confirmation, :if => :password_required?
end
