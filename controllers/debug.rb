# frozen_string_literal: true

require 'rainbow'
require 'nano-bots'

module DebugController
  def self.handler
    {
      ruby: {
        version: RUBY_VERSION
      },
      'nano-bots': {
        version: NanoBot.version
      },
      rainbow: {
        term: ENV['TERM'],
        enabled: Rainbow.enabled,
        ansi: Rainbow('hi').red,
        x11: Rainbow('hi').aliceblue
      }
    }
  end
end
