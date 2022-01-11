# frozen_string_literal: true

require_relative "revbits_pam/version"
require_relative 'revbits_pam/configuration'
require_relative 'revbits_pam/api'

module RevbitsPam
  class Error < StandardError; end
end
