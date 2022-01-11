# frozen_string_literal: true

module RevbitsPam
  module Validators
    module Configuration
      def validated_options_for(type)
        case type
        when :pam
          pam_validated_options
        when :aws
          # TODO: need to implement this part when server is ready to handle AWS request
          {}
        else
          raise "Invalid 'auth_type' provided"
        end
      end

      private

      def pam_validated_options
        validate_appliance_url
        validate_api_key

        {
          appliance_url: RevbitsPam.config.appliance_url,
          api_key: RevbitsPam.config.api_key
        }
      end

      def validate_appliance_url
        if RevbitsPam.config.appliance_url.nil? || RevbitsPam.config.appliance_url.empty?
          raise "No 'appliance_url' provided"
        end
      end

      def validate_api_key
        if RevbitsPam.config.api_key.nil? || RevbitsPam.config.api_key.empty?
          raise "No 'api_key' provided"
        end
      end
    end
  end
end
