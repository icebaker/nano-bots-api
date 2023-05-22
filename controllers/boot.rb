# frozen_string_literal: true

require_relative '../components/log'
require_relative '../components/ddos'

module BootController
  def self.boot!
    DDOS.setup!
    Log.instance.logger.info("Starting server on port #{ENV.fetch('PORT')}")
  end
end
