class Server < ActiveRecord::Base
  has_and_belongs_to_many :hubs
  attr_accessible :end_date, :host, :loginable, :name, :registrable,
    :speed, :start_date, :version, :world_id, :code

  validates :host, presence: true, travian_host: true
  validates :speed, numericality: { only_integer: true }
  validates :start_date, presence: true
  validates :version, format: { with: /\A\d\.\d(?:\.\d)?\Z/ }
  validates :world_id, presence: true

  scope :find_by_hub, lambda {|code| includes(:hubs).where("hubs.code = ?", code) }
  scope :active, where("end_date IS NULL")
  scope :archived, where("end_date IS NOT NULL")

end
