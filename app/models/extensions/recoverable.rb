require 'active_support/concern'
module Extensions
  module Recoverable
    extend ActiveSupport::Concern

    def reset_password(new_password, new_pasword_confirmation=nil)
      self.password = new_password
      self.password_confirmation = new_pasword_confirmation

      clear_reset_password_token if valid?
      save
    end

    def send_reset_password_instructions
      generate_reset_password_token!
      UserMailer.password_reset(self).deliver
    end

    def generate_reset_password_token
      self.reset_password_token = self.class.reset_password_token
      self.reset_token_sent_at = DateTime.now.utc
      self.reset_password_token
    end

    def generate_reset_password_token!
      generate_reset_password_token && save(validate: false)
    end

  protected

    def clear_reset_password_token
      self.reset_token_sent_at = nil
      self.reset_password_token = nil
    end

    module ClassMethods

      def reset_password_token
        generate_token(:reset_password_token)
      end

    end
  end
end
