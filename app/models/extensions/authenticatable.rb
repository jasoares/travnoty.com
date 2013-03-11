require 'active_support/concern'
module Extensions
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      attr_accessor :password
      before_save :encrypt_password
    end

    def encrypt_password
      if password.present?
        self.password_salt = BCrypt::Engine.generate_salt
        self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      end
    end

    def is_token_expired?(column)
      self[:"#{column}_sent_at"] + self.class.token_valid_duration < DateTime.now.utc
    end

    module ClassMethods

      def authenticate(handle, password)
        authable = self.where(email: handle).first || self.where(username: handle).first
        if authable && authable.password_hash == BCrypt::Engine.hash_secret(password, authable.password_salt)
          authable
        else
          nil
        end
      end

      def generate_token(column)
        loop do
          token = SecureRandom.urlsafe_base64(15)
          break token unless self.exists?(column => token)
        end
      end

      def token_valid_duration
        3.hours
      end

    end
  end
end
