class ApiKey < ActiveRecord::Base
  belongs_to :travian_account
  attr_accessible :key

  before_create :generate_key
  before_save :default_values

  def generate_key
    self.key = self.class.generate_key
  end

  def default_values
    self.valid_for ||= 5.days
  end

  def expired?
    self.created_at + self.valid_for > Time.now
  end

  class << self

    def generate_key
      loop do
        key = SecureRandom.urlsafe_base64(15)
        break key unless self.exists?(:key => key)
      end
    end

  end
end
