require 'active_support/concern'
module Extensions
  module Confirmable
    extend ActiveSupport::Concern

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
      confirmation_sent_at + self.class.confirmation_period < DateTime.now.utc
    end

    def generate_confirmation_token
      loop do
        self.confirmation_token = SecureRandom.base64(15)
        break unless self.class.where(confirmation_token: self.confirmation_token).first
      end
      self.confirmation_sent_at = DateTime.now.utc
    end

    module ClassMethods

      def confirmation_period
        4.hours
      end

    end
  end
end
