require 'active_support/concern'
module Extensions
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      attr_accessor :password
      before_validation :normalize_email
      before_save :encrypt_password
    end

    def encrypt_password
      if password.present?
        self.password_salt = BCrypt::Engine.generate_salt
        self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      end
    end

  private

    def is_token_expired?(column)
      self[:"#{column}_sent_at"] + self.class.token_valid_duration < DateTime.now.utc
    end

    def normalize_email
      self.email = self.class.normalize_email(email)
    end

    module ClassMethods

      def authenticate(handle, password)
        authable = find_by_normalized_email(handle) || find_by_username(handle)
        if authable && authable.password_hash == BCrypt::Engine.hash_secret(password, authable.password_salt)
          authable
        else
          nil
        end
      end

      def find_by_normalized_email(email)
        self.find_by_email normalize_email(email)
      end

      def find_by_username(username)
        self.where('lower(username) = ?', username.downcase).first
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

      def normalize_email(email)
        email.strip.downcase
      end

    end
  end
end
