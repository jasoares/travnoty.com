class Hub < ActiveRecord::Base
  has_many :mirrors, class_name: 'Hub', foreign_key: 'main_hub_id'
  belongs_to :main_hub, class_name: 'Hub', foreign_key: 'main_hub_id'
  has_many :servers
  attr_accessible :code, :host, :name, :language

  validates :name, presence: true
  validates :host, presence: true, uniqueness: { case_sensitive: false }, travian_host: true
  validates :code, length: { minimum: 2 }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z]{2,6}\Z/ }
  validates :language, presence: true, length: { minimum: 2 }

  scope :mirrors, -> { where 'main_hub_id is not null' }
  scope :main_hubs, -> { where 'main_hub_id is null' }

  def mirror?
    main_hub_id ? true : false
  end

  alias_method :my_servers, :servers
  def servers
    mirror? ? main_hub.servers : my_servers
  end
end
