# frozen_string_literal: true

require 'roda'
require 'rack/cors'

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

  route { |r| HTTP.routes(r, request, response) }
end
