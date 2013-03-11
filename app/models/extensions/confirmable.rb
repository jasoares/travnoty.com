require 'active_support/concern'
module Extensions
  module Confirmable
    extend ActiveSupport::Concern

    included do
      before_create :generate_confirmation_token
      after_create  :send_confirmation_instructions
    end

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
      is_token_expired?(:confirmation)
    end

    def generate_confirmation_token
      self.confirmation_token = self.class.confirmation_token
      self.confirmation_sent_at = DateTime.now.utc
    end

    def send_confirmation_instructions
      UserMailer.email_confirmation(self).deliver
    end

    def resend_confirmation_instructions
      send_confirmation_instructions if confirmation_pending?
    end

    module ClassMethods

      def confirmation_token
        generate_token(:confirmation_token)
      end

    end
  end
end
