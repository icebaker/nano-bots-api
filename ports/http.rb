# frozen_string_literal: true

require_relative '../controllers/index'
require_relative '../controllers/debug'
require_relative '../controllers/cartridges'

require 'newrelic_rpm' if ENV.fetch('NANO_BOTS_NEW_RELIC', nil).to_s == 'true'

module HTTP
  def self.routes(route, request, response)
    new_relic = ENV.fetch('NANO_BOTS_NEW_RELIC', nil).to_s == 'true'
    ip = request.env['HTTP_X_FORWARDED_FOR']&.split(',')&.first || request.ip

    environment = {
      NANO_BOTS_END_USER: "#{ip}/#{request.get_header('HTTP_NANO_BOTS_END_USER')}"
    }

    route.root do
      NewRelic::Agent.set_transaction_name('GET/') if new_relic
      IndexController.handler
    end

    route.get 'debug' do
      NewRelic::Agent.set_transaction_name('GET/debug') if new_relic
      DebugController.handler({ ip: }, request, environment)
    end

    route.get 'cartridges' do
      NewRelic::Agent.set_transaction_name('GET/cartridges') if new_relic
      result = CartridgesController.index
      response.status = result[:status]
      result[:body]
    end

    route.post 'cartridges/stream' do
      NewRelic::Agent.set_transaction_name('POST/cartridges/stream') if new_relic
      result = CartridgesController.create_stream(request.body.read, environment)
      response.status = result[:status]
      result[:body]
    end

    route.post 'cartridges/source' do
      NewRelic::Agent.set_transaction_name('POST/cartridges/source') if new_relic
      result = CartridgesController.source(request.body.read)
      response.status = result[:status]
      result[:body]
    end

    route.get 'cartridges/stream', String do |id|
      NewRelic::Agent.set_transaction_name('GET/cartridges/stream') if new_relic
      result = CartridgesController.get_stream(id)
      response.status = result[:status]
      result[:body]
    end

    route.post 'cartridges' do
      NewRelic::Agent.set_transaction_name('POST/cartridges') if new_relic
      result = CartridgesController.run(request.body.read, environment)
      response.status = result[:status]
      result[:body]
    end
  end
end
