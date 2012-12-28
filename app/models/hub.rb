class Hub < ActiveRecord::Base
  include Travian::Hub

  has_many :servers
  attr_accessible :code, :host, :name

  validates :name, presence: true
  validates :host, uniqueness: { case_sensitive: false }, travian_host: true
  validates :code, length: { minimum: 2 }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z]{2,6}\Z/ }

  def self.update!
    Hub.fetch_list!.values.each do |attrs|
      hub = Hub.find_or_initialize_by_host(attrs[:host])
      hub.attributes = attrs
      hub.save if hub.new_record? or hub.changed?
    end
  end
end
