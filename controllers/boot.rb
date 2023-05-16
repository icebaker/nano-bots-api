# frozen_string_literal: true

require_relative '../components/log'

module BootController
  def self.boot!
    Log.instance.logger.info("Starting server on port #{ENV.fetch('PORT')}")
  end
end
