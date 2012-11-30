require 'httparty'
require 'nokogiri'

module Updater
  extend self

  def load_hubs!
    hub_data![:flags].values.inject(&:merge)
  end

  private

  def hub_data!
    world_page = Nokogiri::HTML(HTTParty.get('http://www.travian.com').body)
    world_page.css('div#country_select').text.gsub(/\n|\t/, '').match(/\(({container:[^\)]+).+/)
    eval($1.gsub(/,'/, ", ").gsub(/':/, ": ").gsub(/\{'/, "{ "))
  end

  def js_hash_to_ruby_hash(js_hash)
    eval(js_hash.gsub(/,'/, ", ").gsub(/':/, ": ").gsub(/\{'/, "{ "))
  end
end
