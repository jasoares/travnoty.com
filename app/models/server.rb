class Server < ActiveRecord::Base
  belongs_to :hub
  attr_accessible :host, :name, :speed, :start_date, :version, :world_id, :code

  validates :host, presence: true, travian_host: true
  validates :speed, numericality: { only_integer: true }
  validates :start_date, presence: true
  validates :version, format: { with: /\A\d\.\d(?:\.\d)?\Z/ }
  validates :world_id, presence: true

  scope :active, where("end_date IS NULL")
  scope :archived, where("end_date IS NOT NULL")

end
