# frozen_string_literal: true

module RevbitsPam
  module Authenticators
    class PAM < HTTP
      class << self
        # @param variable_id variable you want to fetch from RevBits PAM.
        # @param public_key_a public key to encrypt data
        # @param public_key_b public key to encrypt data
        # @param options valid values are [:appliance_url, :api_key].
        def get(variable_id, public_key_a, public_key_b, options = {})
          uri = URI.parse("#{options[:appliance_url]&.chomp}/api/v1/secretman/GetSecretV2/#{variable_id}")
          request = Net::HTTP::Get.new(uri)
          request['Apikey'] = options[:api_key]
          request['Publickeya'] = public_key_a.to_s
          request['Publickeyb'] = public_key_b.to_s

          req_options = {
            use_ssl: uri.scheme == 'https',
          }

          super(uri, request, req_options)
        end
      end
    end
  end
end
