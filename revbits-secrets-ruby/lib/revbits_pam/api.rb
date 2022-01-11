# frozen_string_literal: true

require_relative 'configuration'
require_relative 'secure'
require_relative 'http'
require_relative 'validators/configuration'
require_relative 'managers/auth_manager'
require_relative 'authenticators/pam'
require_relative 'authenticators/aws'

module RevbitsPam
  class API
    class << self
      def fetch_secret(variable_id)

        secret_creators = {
          prime: 23,
          generated: 9,
        }

        private_key_a, private_key_b = Secure.private_keys

        public_key_a, public_key_b = Secure.public_keys(private_key_a, private_key_b, secret_creators)

        encrypted_values = Managers::AuthManager.fetch_secret(variable_id, public_key_a, public_key_b)

        secret = Secure.secret(encrypted_values, private_key_a, private_key_b, secret_creators)

        Secure.decrypt(secret, encrypted_values.dig('value'))
      end
    end
  end
end
