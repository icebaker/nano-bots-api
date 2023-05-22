# frozen_string_literal: true

require 'dotenv/load'

require 'newrelic_rpm' if ENV.fetch('NANO_BOTS_NEW_RELIC', nil).to_s == 'true'

require_relative 'controllers/app'
require_relative 'controllers/boot'

BootController.boot!

run AppController.app
