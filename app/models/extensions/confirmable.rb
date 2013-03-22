require 'active_support/concern'
module Extensions
  module Confirmable
    extend ActiveSupport::Concern

    included do
      before_create :generate_confirmation_token
      after_create  :send_confirmation_instructions
      after_validation :regenerate_confirmation_token, :if => :email_changed?, :on => :update
      after_update  :send_confirmation_instructions, :if => :need_reconfirmation?
    end

    def confirm!(token)
      return false unless self.confirmation_token == token
      self.confirmation_token = nil
      self.confirmed_at = DateTime.now.utc
      save
    end

    def confirmed?
      !!self.confirmed_at
    end

    def generate_confirmation_token
      self.confirmation_token = self.class.confirmation_token
    end

    def send_confirmation_instructions
      self.confirmation_sent_at = DateTime.now.utc
      UserMailer.email_confirmation(self).deliver
    end

    def resend_confirmation_instructions
      send_confirmation_instructions unless confirmed?
    end

    def regenerate_confirmation_token
      self.confirmed_at = nil
      self.confirmation_token = self.class.confirmation_token
      self.confirmation_sent_at = DateTime.now.utc
      @need_reconfirmation = true
    end

    def need_reconfirmation?
      @need_reconfirmation
    end

    module ClassMethods

      def confirmation_token
        generate_token(:confirmation_token)
      end

    end
  end
end
