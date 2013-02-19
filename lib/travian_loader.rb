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

source = Rails.configuration.travian_loader_source
require 'travian_proxy' if source == :travian_proxy
TravianLoader.source = source.to_s.classify.constantize
