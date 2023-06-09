# frozen_string_literal: true

require_relative '../static/api'
require 'rainbow'
require 'nano-bots'

module DebugController
  def self.handler(params, request, environment)
    {
      ruby: {
        version: RUBY_VERSION
      },
      api: API,
      'nano-bots': {
        version: NanoBot.version
      },
      rainbow: {
        enabled: Rainbow.enabled,
        ansi: Rainbow('hi').red,
        x11: Rainbow('hi').aliceblue
      },
      environment:,
      security: NanoBot.security.check,
      client: {
        ip: {
          built: params[:ip],
          HTTP_X_FORWARDED_FOR: request.env['HTTP_X_FORWARDED_FOR'],
          request: request.ip
        }
      }
    }
  end
end
