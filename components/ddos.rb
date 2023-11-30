# frozen_string_literal: true

require_relative 'fake_redis'

class DDOS
  SECONDS = 1

  def self.setup!
    active = ENV.fetch('NANO_BOTS_RACK_ATTACK', nil)

    return unless ['true', true].include?(active)

    Rack::Attack.cache.store = FakeRedis.new

    # No access without the NANO_BOTS_END_USER header.
    Rack::Attack.blocklist('No User Identifier') do |request|
      identifier = request.get_header('HTTP_NANO_BOTS_END_USER')
      request.path != '/' && (identifier.nil? || identifier.to_s.strip.empty?)
    end

    # How many free OpenAI Requests are you willing to allow?
    # 100 people making 1 request every 5 seconds results in 1,200 requests per minute.
    Rack::Attack.throttle('OpenAI Requests', limit: 1200, period: 60 * SECONDS) do |request|
      'openai' if request.post? && (request.path == '/cartridges' || request.path == '/cartridges/stream')
    end

    # How many requests other than Open AI's ones are you willing to allow?
    # If 1 person makes 1 request every 1 millisecond, the result is 60,000 requests per minute.
    Rack::Attack.throttle('Overall by IP', limit: 60_000, period: 60 * SECONDS) do |request|
      request.env['HTTP_X_FORWARDED_FOR']&.split(',')&.first || request.ip
    end
  end
end
