class Server < ActiveRecord::Base
  belongs_to :hub
  has_many :rounds
  attr_accessible :host, :name, :speed, :world_id, :code

  validates :host, presence: true, travian_host: true
  validates :speed, numericality: { only_integer: true }

  def current_round
    rounds.where('start_date IS NOT NULL').order('start_date DESC').first
  end

  def restarting?
    current_round.restarting?
  end

  def ended?
    current_round.ended?
  end

  def running?
    current_round.running?
  end

  def url
    "http://#{host}"
  end

  module Scopes
    def ended
      without_rounds + Round.includes(:server).ended.map(&:server)
    end

    def restarting
      Round.includes(:server).restarting.map(&:server)
    end

    def running
      Round.includes(:server).running.map(&:server)
    end

    def without_rounds
      includes(:rounds).where('rounds.id is null')
    end

    def classic
      where('host LIKE ?', 'tc%')
    end
  end
  extend Scopes
end
