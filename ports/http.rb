# frozen_string_literal: true

require_relative '../controllers/index'
require_relative '../controllers/debug'
require_relative '../controllers/cartridges'

module HTTP
  def self.routes(route, request, response)
    ip = request.env['HTTP_X_FORWARDED_FOR']&.split(',')&.first || request.ip

    route.root do
      IndexController.handler
    end

    route.get 'debug' do
      DebugController.handler({ ip: }, request)
    end

    route.get 'cartridges' do
      result = CartridgesController.index
      response.status = result[:status]
      result[:body]
    end

    route.post 'cartridges/stream' do
      result = CartridgesController.create_stream(request.body.read)
      response.status = result[:status]
      result[:body]
    end

    route.post 'cartridges/source' do
      result = CartridgesController.source(request.body.read)
      response.status = result[:status]
      result[:body]
    end

    route.get 'cartridges/stream', String do |id|
      result = CartridgesController.get_stream(id)
      response.status = result[:status]
      result[:body]
    end

    route.post 'cartridges' do
      result = CartridgesController.run(request.body.read)
      response.status = result[:status]
      result[:body]
    end
  end
end
