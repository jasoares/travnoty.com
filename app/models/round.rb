class Round < ActiveRecord::Base
  belongs_to :server
  attr_accessible :end_date, :start_date, :version

  validates :start_date, presence: true
  validates :version, format: { with: /\A\d\.\d(?:\.\d)?\Z/ }
end
