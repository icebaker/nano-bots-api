# frozen_string_literal: true

require 'securerandom'
require 'singleton'
require 'concurrent-ruby'

class Stream
  include Singleton

  attr_reader :logger

  def initialize
    @streams = Concurrent::Map.new
  end

  def get(id)
    @streams[id]
  end

  def self.template
    {
      id: nil,
      started_at: nil,
      finished_at: nil,
      state: 'unknown',
      output: ''
    }.clone
  end

  def create
    id = SecureRandom.hex

    @streams[id] = Stream.template
    @streams[id][:id] = id
    @streams[id][:started_at] = Time.now
    @streams[id][:state] = 'pending'

    @streams[id]
  end
end
