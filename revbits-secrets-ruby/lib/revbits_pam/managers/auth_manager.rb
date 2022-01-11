# frozen_string_literal: true

module RevbitsPam
  module Managers
    module AuthManager
      class << self
        include Validators::Configuration

        def fetch_secret(variable_id, public_key_a, public_key_b)
          case RevbitsPam.config.auth_type
          when :pam
            Authenticators::PAM.get(variable_id, public_key_a, public_key_b,
                                    validated_options_for(:pam))
          when :aws
            Authenticators::AWS.get(variable_id, public_key_a, public_key_b,
                                    validated_options_for(:aws))
          else
            raise "Invalid 'auth_type'"
          end
        end
      end
    end
  end
end
