require 'travian_proxy'

module TravianLoader
  extend self

  attr_accessor :source

  def servers
    @source.servers
  end

  def hubs(options={})
    @source.hubs(options)
  end

  def Hub(obj)
    @source.Hub(obj)
  end

  def Server(obj)
    @source.Server(obj)
  end
end

TravianLoader.source = Rails.configuration.travian_loader_source.to_s.classify.constantize
