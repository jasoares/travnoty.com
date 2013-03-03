class Email < ActiveRecord::Base
  belongs_to :user
  attr_accessible :confirmation_sent_at, :confirmation_token, :confirmed_at, :address, :main_address

  before_create :generate_confirmation_token
  after_create  :send_confirmation_instructions

  validates :address, presence: true, uniqueness: { case_sensitive: false }, email_format: true
  validates :user, presence: true

  def confirm
    unless confirmation_pending?
      self.errors[:base] << 'Already confirmed.'
      return false
    end

    if confirmation_period_expired?
      self.errors[:base] << 'Confirmation period expired.'
      return false
    end
    
    self.confirmed_at = DateTime.now.utc
    self.confirmation_token = nil
    save
  end

  def confirmed?
    !!confirmed_at
  end

  def confirmation_pending?
    !!confirmation_token
  end

  def confirmation_period_expired?
    self.confirmation_sent_at + self.class.confirmation_period < DateTime.now.utc
  end

  def generate_confirmation_token
    loop do
      self.confirmation_token = SecureRandom.base64(15)
      break unless Email.where(confirmation_token: self.confirmation_token).first
    end
    self.confirmation_sent_at = DateTime.now.utc
  end

protected

  def send_confirmation_instructions
    UserMailer.email_confirmation(self.user, self).deliver
  end

  class << self

    def confirmation_period
      4.hours
    end

  end
end
