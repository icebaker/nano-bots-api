# frozen_string_literal: true

require 'logger'
require 'singleton'

class Log
  include Singleton

  attr_reader :logger

  def initialize
    @logger = Logger.new($stdout)
  end
end
