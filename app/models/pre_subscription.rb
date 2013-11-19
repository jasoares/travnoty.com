class PreSubscription < ActiveRecord::Base
  belongs_to :hub

  before_validation :normalize_email
  after_create :send_pre_subscription_confirmation

  validates :name,  presence: true
  validates :email, presence: true, email_format: true
  validates :email, uniqueness: { case_sensitive: false, message: "is already subscribed" }

  def normalize_email
    self.email = self.class.normalize_email(email)
  end

  def send_pre_subscription_confirmation
    UserMailer.pre_subscription_confirmation(self).deliver
  end

  class << self

    def find_by_normalized_email(email)
      self.find_by_email normalize_email(email)
    end

    def normalize_email(email)
      email and email.strip.downcase
    end

  end
end
