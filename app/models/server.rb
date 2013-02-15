class Server < ActiveRecord::Base
  belongs_to :hub
  has_many :rounds, order: "start_date desc"
  attr_accessible :host, :name, :speed, :world_id, :code

  validates :host, presence: true, uniqueness: { case_sensitive: false }, travian_host: true
  validates :speed, numericality: { only_integer: true, greater_than: 0 }

  def self.ended
    subquery = <<-SQL
      SELECT r.server_id
      FROM rounds AS r
      GROUP BY r.server_id
      HAVING every(r.end_date is not null)
    SQL

    includes(:rounds).
    where("rounds.id is null OR servers.id IN (#{subquery})")
  end

  def self.restarting
    joins(:rounds).where('rounds.start_date > ?', DateTime.now)
  end

  def self.running
    joins(:rounds).
    where('rounds.end_date is null and rounds.start_date < ?', DateTime.now)
  end

  def current_round
    rounds.first
  end

  def url
    "http://#{host}"
  end
end
