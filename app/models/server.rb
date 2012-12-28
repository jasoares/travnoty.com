class Server < ActiveRecord::Base
  include Travian::Server

  belongs_to :hub
  attr_accessible :end_date, :host, :loginable, :name, :registrable,
    :speed, :start_date, :version, :world_id, :code

  validates :host, presence: true, travian_host: true
  validates :speed, numericality: { only_integer: true }
  validates :start_date, presence: true
  validates :version, format: { with: /\A\d\.\d(?:\.\d)?\Z/ }
  validates :world_id, presence: true
  #validates :register, :login, presence: true

  def self.calculate_start_date(days)
    days.days.ago.to_date
  end

  def self.update!(hub)
    Server.fetch_list!(hub) do |code, attrs|
      server = hub.servers.find_or_initialize_by_host(attrs[:host])
      server.attributes = attrs
      server.save! if server.new_record? or server.changed?
    end
  end

end
