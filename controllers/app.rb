# frozen_string_literal: true

require 'roda'
require 'rack/cors'
require 'rack/attack'

require_relative '../ports/http'

class AppController < Roda
  plugin :json
  plugin :all_verbs

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: %i[get post options head delete]
    end
  end

  use Rack::Attack

  route { |r| HTTP.routes(r, request, response) }
end
