class Server < ActiveRecord::Base
  belongs_to :hub
  has_many :rounds
  attr_accessible :host, :name, :speed, :world_id, :code

  validates :host, presence: true, travian_host: true, uniqueness: true
  validates :speed, numericality: { only_integer: true, greater_than: 0 }

  def current_round
    rounds.latest
  end

  def url
    "http://#{host}"
  end
end
