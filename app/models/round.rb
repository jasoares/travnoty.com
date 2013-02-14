class Round < ActiveRecord::Base
  belongs_to :server
  attr_accessible :end_date, :start_date, :version

  validates :start_date, presence: true
  validates :start_date, uniqueness: { scope: :server_id }
  validates :end_date, date_coherence: true, uniqueness: { scope: :server_id }
  validates :version, format: { with: /\A\d\.\d(?:\.\d)?\Z/ }

  def self.running
    where('end_date is null AND start_date < ?', Time.now.utc)
  end

  def self.restarting
    where('start_date > ?', Time.now.utc)
  end

  def self.ended
    select('rounds.server_id').group('rounds.server_id').having('every(rounds.end_date is not null)')
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
