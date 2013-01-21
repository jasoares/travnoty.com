class Server < ActiveRecord::Base
  belongs_to :hub
  attr_accessible :host, :name, :speed, :world_id, :code

  validates :host, presence: true, travian_host: true
  validates :speed, numericality: { only_integer: true }
  validates :world_id, presence: true

end
