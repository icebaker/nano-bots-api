# frozen_string_literal: true

require 'dotenv/load'

require_relative 'controllers/app'
require_relative 'controllers/boot'

BootController.boot!

run AppController.app
