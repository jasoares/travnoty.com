class TravianAccount < ActiveRecord::Base
  belongs_to :round
  belongs_to :user
  attr_accessible :uid, :username

  validates :username, presence: true, uniqueness: { scope: :round_id }
  validates :uid, presence: true, numericality: { only_integer: true, greater_than: 2 }
  validates :round, presence: true
  validates :user, presence: true
end
