#encoding: utf-8

module TravianProxy
  extend self

  ##
  # TravianPoxy can be stubbed with data by assigning a hash in the following format
  # to TravianProxy.data.
  #
  # net: {
  #   code: :net,
  #   name: 'Spain',
  #   host: 'www.travian.net',
  #   language: 'es',
  #   main_hub: '',
  #   servers: {
  #     ts1: {
  #       code: 'ts1',
  #       host: 'ts1.travian.net',
  #       name: 'Servidor 1',
  #       world_id: 'net11',
  #       speed: 1,
  #       start_date: DateTime.new(2012,7,10)
  #     }
  #   }
  # }

  attr_accessor :data

  def servers
    hubs.map(&:servers).inject(&:+)
  end

  def hubs(options={})
    data.values.map { |hash| Hub.new(*hash.values) }
  end

  def Hub(obj)
    host = obj.is_a?(String) ? obj : obj.host
    hubs.find { |hub| hub.host == host }
  end

  def Server(obj)
    host = obj.is_a?(String) ? obj : obj.host
    servers.find { |server| server.host == host }
  end

end

class TravianProxy::Hub

  attr_reader :host, :name, :language

  def initialize(code, name, host, language, mirrored_hub=nil, servers={})
    @code, @name, @host, @language = code, name, host, language
    @mirrored_hub, @servers = mirrored_hub, servers
  end

  def attributes
    { code: code, host: host, name: name, language: language }
  end

  def code
    @code.to_s
  end

  def mirror?
    @mirrored_hub ? true : false
  end

  def mirrored_hub
    TravianProxy::Hub("www.travian.#{@mirrored_hub}") if @mirrored_hub
  end

  def servers
    @servers.values.map { |hash| TravianProxy::Server.new(code, *hash.values) }
  end
end

class TravianProxy::Server

  attr_reader :hub_code, :code, :host, :name, :world_id, :speed

  def initialize(hub_code, code, host, name, world_id, speed, start_date)
    @hub_code, @code, @host, @name = hub_code, code, host, name
    @world_id, @speed, @start_date = world_id, speed, start_date
  end

  def attributes
    { code: code, host: host, name: name, world_id: world_id, speed: speed }
  end

  def ended?
    @start_date.nil?
  end

  def restarting?
    @start_date ? @start_date > DateTime.now : false
  end

  def running?
    @start_date ? @start_date < DateTime.now : false
  end

  def restart_date
    restarting? ? @start_date : nil
  end

  def start_date
    @start_date.nil? || @start_date > DateTime.now ? nil : @start_date
  end

  def version
    "4.0"
  end
end
