class Server < ActiveRecord::Base
  belongs_to :hub
  has_many :rounds, -> { order "start_date desc" }

  validates :host, presence: true, uniqueness: { case_sensitive: false }, travian_host: true
  validates :speed, numericality: { only_integer: true, greater_than: 0 }

  scope :without_classics, -> { where "host NOT ILIKE 'tc%'" }

  class << self
    def ended
      subquery = <<-SQL
        SELECT r.server_id
        FROM rounds AS r
        GROUP BY r.server_id
        HAVING every(r.end_date is not null)
      SQL

      includes(:rounds).
      where("rounds.id is null OR servers.id IN (#{subquery})").references(:rounds)
    end

    def restarting
      joins(:rounds).where('rounds.start_date > ?', DateTime.now)
    end

    def running
      joins(:rounds).
      where('rounds.end_date is null and rounds.start_date < ?', DateTime.now)
    end

    def with_rounds
      joins("LEFT OUTER JOIN rounds ON servers.id = rounds.server_id").
      where("rounds.server_id IS NOT NULL")
    end
  end

  def current_round
    rounds.first
  end

  def url
    "http://#{host}"
  end

  def estimated_end_date
    (current_round.start_date + rounds.average("end_date - start_date").to_i.days).to_datetime
  end
end
