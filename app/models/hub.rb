class Hub < ActiveRecord::Base
  attr_accessible :code, :host, :name

  validates :name, presence: true
  validates :host, travian_host: true
  validates :code, length: { minimum: 2 }, uniqueness: { case_sensitive: true }, format: { with: /\A[a-z]{2,6}\Z/ }

  class << self

    TLDS = YAML.load_file("#{Rails.root}/db/seeds/tld_to_country_name.yml")

    def update!
      hub_data.each_pair do |code, host|
        begin
          hub = Hub.find_or_initialize_by_code code
          hub.host = host
          hub.name = TLDS[code][:country]
          action = hub.new_record? ? 'add' : 'updat'
          Rails.logger.info "#{hub.name} hub #{action}ed." if hub.new_record? || hub.changed? and hub.save!
        rescue Exception => msg
          Rails.logger.error "Error #{action}ing #{TLDS[code][:country]} hub."
        end
      end
    end

    private

    def hub_data
      data[:flags].values.inject(&:merge)
    end

    def data
      world_page = Nokogiri::HTML(HTTParty.get('http://www.travian.com').body)
      world_page.css('div#country_select').text.gsub(/\n|\t/, '').match(/\(({container:[^\)]+).+/)
      js_hash_to_ruby_hash($1)
    end

    def js_hash_to_ruby_hash(js_hash)
      eval(js_hash.gsub(/,'/, ", ").gsub(/':/, ": ").gsub(/\{'/, "{ "))
    end
  end
end
