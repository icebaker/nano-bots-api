# frozen_string_literal: true

require 'nano-bots'

require 'newrelic_rpm' if ENV.fetch('NANO_BOTS_NEW_RELIC', nil).to_s == 'true'

require './components/stream'
require './logic/safety'

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

    { body: state, status: state[:state] == 'failed' ? 500 : 200 }
  end

  def self.create_stream(params, environment)
    params = JSON.parse(params)

    stream = Stream.instance.create

    nbot = NanoBot.new(
      cartridge: SafetyLogic.ensure_cartridge_is_safe_to_run(params['cartridge']),
      state: params['state'],
      environment:
    )

    thread_klass = if ENV.fetch('NANO_BOTS_NEW_RELIC', nil).to_s == 'true'
                     NewRelic::TracedThread
                   else
                     Thread
                   end

    thread_klass.new do
      as = params['as'] || 'eval'

      callback = lambda do |content, _fragment, finished|
        Stream.instance.get(stream[:id])[:output] = if finished
                                                      "#{content}#{if as == 'repl'
                                                                     "#{content == '' ? '' : "\n"}#{nbot.prompt}"
                                                                   else
                                                                     ''
                                                                   end}"
                                                    else
                                                      content
                                                    end

        return unless finished

        Stream.instance.get(stream[:id])[:finished_at] = Time.now
        Stream.instance.get(stream[:id])[:state] = 'finished'
      end

      if params['action'] == 'boot'
        nbot.boot(as:, &callback)
      else
        nbot.eval(params['input'], as:, &callback)
      end
    rescue StandardError => e
      Stream.instance.get(stream[:id])[:finished_at] = Time.now
      Stream.instance.get(stream[:id])[:state] = 'failed'
      Stream.instance.get(stream[:id])[:error] = { message: e.message, backtrace: e.backtrace }
    end

    { body: stream, status: 200 }
  end

  def self.run(params, environment)
    params = JSON.parse(params)
    nbot = NanoBot.new(
      cartridge: SafetyLogic.ensure_cartridge_is_safe_to_run(params['cartridge']),
      state: params['state'],
      environment:
    )
    state = Stream.template
    state[:started_at] = Time.now

    as = params['as'] || 'eval'

    state[:output] = if params['action'] == 'boot'
                       content = nbot.boot(as:)
                       "#{content}#{if as == 'repl'
                                      "#{content == '' ? '' : "\n"}#{nbot.prompt}"
                                    else
                                      ''
                                    end}"
                     else
                       "#{nbot.eval(params['input'], as:)}#{as == 'repl' ? "\n#{nbot.prompt}" : ''}"
                     end

    state[:state] = 'finished'
    state[:finished_at] = Time.now

    { body: state, status: 200 }
  end
end
