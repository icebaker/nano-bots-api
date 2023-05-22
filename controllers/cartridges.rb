# frozen_string_literal: true

require 'nano-bots'

require_relative '../components/stream'

module CartridgesController
  def self.index
    cartridges = NanoBot.cartridges

    cartridges = cartridges.map do |cartridge|
      {
        system: {
          id: cartridge[:system][:id]
        },
        meta: {
          name: cartridge[:meta][:name],
          author: cartridge[:meta][:author],
          version: cartridge[:meta][:version],
          symbol: cartridge[:meta][:symbol],
          description: cartridge[:meta][:description]
        }
      }
    end

    default_override = cartridges.find do |cartridge|
      cartridge[:system][:id].to_s.downcase == 'default'
    end

    if default_override
      cartridges = cartridges.filter do |cartridge|
        cartridge[:system][:id] != '-' && cartridge[:system][:id].to_s.downcase != 'default'
      end.prepend(default_override)
    end

    { body: cartridges, status: 200 }
  end

  def self.source(params)
    params = JSON.parse(params)

    cartridge = NanoBot.cartridges.find do |cartridge|
      cartridge[:system][:id] == params['id']
    end

    if cartridge
      cartridge = {
        system: {
          id: cartridge[:system][:id]
        },
        meta: {
          name: cartridge[:meta][:name],
          author: cartridge[:meta][:author],
          version: cartridge[:meta][:version],
          symbol: cartridge[:meta][:symbol],
          description: cartridge[:meta][:description]
        }
      }
    end

    { body: cartridge, status: 200 }
  end

  def self.get_stream(id)
    state = Stream.instance.get(id)

    state = Stream.template if state.nil?

    { body: state, status: 200 }
  end

  def self.create_stream(params)
    params = JSON.parse(params)

    stream = Stream.instance.create

    nbot = NanoBot.new(cartridge: params['cartridge'], state: params['state'])

    Thread.new do
      nbot.eval(params['input']) do |content, _fragment, finished|
        Stream.instance.get(stream[:id])[:output] = content
        if finished
          Stream.instance.get(stream[:id])[:finished_at] = Time.now
          Stream.instance.get(stream[:id])[:state] = 'finished'
        end
      end
    end

    { body: stream, status: 200 }
  end

  def self.run(params)
    params = JSON.parse(params)
    nbot = NanoBot.new(cartridge: params['cartridge'], state: params['state'])

    state = Stream.template
    state[:started_at] = Time.now
    state[:output] = nbot.eval(params['input'])
    state[:state] = 'finished'
    state[:finished_at] = Time.now

    { body: state, status: 200 }
  end
end
