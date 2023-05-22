# frozen_string_literal: true

class FakeRedis
  def initialize
    @store = {}
  end

  def read(key)
    @store[key]
  end

  def write(key, value, _options = {})
    @store[key] = value
  end

  def increment(key, amount, _options = {})
    @store[key] ||= 0
    @store[key] += amount
  end

  def fetch(key, _options = {}, &)
    @store.fetch(key, &)
  end
end
