class Round < ActiveRecord::Base
  belongs_to :server
  has_many :travian_accounts

  validates :server_id, presence: true
  validates :start_date, presence: true, uniqueness: { scope: :server_id }
  validates :start_date, cross_rounds_date_coherence: true
  validates :end_date, date_coherence: true, uniqueness: { scope: :server_id }
  validates :version, format: { with: /\A\d\.\d(?:\.\d)?\Z/ }

  scope :running, -> { where 'end_date is null AND start_date < ?', Time.now.utc }
  scope :restarting, -> { where 'start_date > ?', Time.now.utc }
  scope :ended, -> { where 'end_date IS NOT NULL' }

  def self.last_end_date_by(server)
    round = select('rounds.id, MAX(end_date) AS end_date').
      where(:server_id => server.id).
      where("rounds.end_date IS NOT NULL").
      group("rounds.id, rounds.server_id").first
    round and round.end_date
  end

  def running?
    end_date.nil? && !restarting?
  end

  def ended?
    !running?
  end

  def restarting?
    start_date > Time.now.utc
  end
end
