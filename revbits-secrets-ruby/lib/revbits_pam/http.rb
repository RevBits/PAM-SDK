# frozen_string_literal: true

require 'net/http'
require 'json'

# Root Module for Namespace management
module RevbitsPam
  # Module responsible for fetching data from 'PAM'.
  class HTTP
    class << self
      def get(uri, request, req_options)
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end

        unless response.code.match?(%r{^2})
          raise Net::HTTPError.new("Server error: #{JSON.parse(response.body).dig('errorMessage')}", response)
        end

        JSON.parse(response.body)
      end
    end
  end
end
