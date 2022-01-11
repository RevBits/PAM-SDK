# frozen_string_literal: true

module RevbitsPam
  module Authenticators
    class AWS < HTTP
      class << self
        # @param variable_id variable you want to fetch from RevBits PAM.
        # @param public_key_a public key to encrypt data
        # @param public_key_b public key to encrypt data
        # @param options valid values are [:appliance_url, :api_key].
        def get(variable_id, public_key_a, public_key_b, options = {})
          # TODO: Need to implement when server is ready to handle AWS requests
          raise 'TODO: AWS authenticator is not implemented yet.'
        end
      end
    end
  end
end
