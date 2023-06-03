# frozen_string_literal: true

require 'rainbow'
require 'nano-bots'

module DebugController
  def self.handler(params, request)
    {
      ruby: {
        version: RUBY_VERSION
      },
      'nano-bots': {
        version: NanoBot.version
      },
      rainbow: {
        enabled: Rainbow.enabled,
        ansi: Rainbow('hi').red,
        x11: Rainbow('hi').aliceblue
      },
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
