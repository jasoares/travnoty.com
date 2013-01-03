class Hub < ActiveRecord::Base
  has_and_belongs_to_many :servers
  attr_accessible :code, :host, :name, :language

  validates :name, presence: true
  validates :host, uniqueness: { case_sensitive: false }, travian_host: true
  validates :code, length: { minimum: 2 }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z]{2,6}\Z/ }
  validates :language, presence: true, length: { minimum: 2 }

  def active_servers
    Server.find_by_hub(code).active
  end

  def update_servers!
    servers_found = []
    Travian.hubs[code.to_sym].servers.map do |server|
      record = Server.find_or_initialize_by_host(server.host)
      if record.new_record?
        record.hubs << self
        record.update_attributes(server.attributes)
      end
      servers_found << record
    end
    (self.servers - servers_found).each do |s|
      s.update_attributes(end_date: Date.today)
    end
  end

end
