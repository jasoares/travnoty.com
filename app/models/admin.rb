class Admin < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :timeoutable, :lockable, :validatable

  attr_accessible :email, :password, :password_confirmation
end
