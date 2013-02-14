class Server < ActiveRecord::Base
  belongs_to :hub
  has_many :rounds, order: "start_date desc"
  attr_accessible :host, :name, :speed, :world_id, :code

  validates :host, presence: true, uniqueness: { case_sensitive: false }, travian_host: true
  validates :speed, numericality: { only_integer: true, greater_than: 0 }

  def url
    "http://#{host}"
  end
end
