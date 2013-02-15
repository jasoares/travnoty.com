class Round < ActiveRecord::Base
  belongs_to :server
  attr_accessible :end_date, :start_date, :version

  validates :server_id, presence: true
  validates :start_date, presence: true, uniqueness: { scope: :server_id }
  validates :start_date, cross_rounds_date_coherence: true
  validates :end_date, date_coherence: true, uniqueness: { scope: :server_id }
  validates :version, format: { with: /\A\d\.\d(?:\.\d)?\Z/ }

  def self.running
    where('end_date is null AND start_date < ?', Time.now.utc)
  end

  def self.restarting
    where('start_date > ?', Time.now.utc)
  end

  def self.ended
    select('rounds.server_id').
    group('rounds.server_id').
    having('every(rounds.end_date is not null)')
  end

  def self.last_end_date_by(server)
    round = select('MAX(end_date) AS end_date').
      where(:server_id => server.id).
      group(:server_id).first
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
