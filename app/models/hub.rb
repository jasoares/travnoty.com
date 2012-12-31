class Hub < ActiveRecord::Base
  has_and_belongs_to_many :servers
  attr_accessible :code, :host, :name, :language

  validates :name, presence: true
  validates :host, uniqueness: { case_sensitive: false }, travian_host: true
  validates :code, length: { minimum: 2 }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z]{2,6}\Z/ }
  validates :language, presence: true, length: { minimum: 2 }

end
