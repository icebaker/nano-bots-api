# frozen_string_literal: true

require_relative '../static/api'

module IndexController
  def self.handler
    API
  end
end
