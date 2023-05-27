# frozen_string_literal: true

require 'rainbow'

require_relative '../components/log'
require_relative '../components/ddos'

module BootController
  def self.boot!
    DDOS.setup!
    Rainbow.enabled = true
    Log.instance.logger.info("Starting server on port #{ENV.fetch('PORT')}")
  end
end
