# frozen_string_literal: true

require 'yaml'

module SafetyLogic
  def self.symbolize_keys(object)
    case object
    when ::Hash
      object.each_with_object({}) do |(key, value), result|
        result[key.to_sym] = symbolize_keys(value)
      end
    when Array
      object.map { |e| symbolize_keys(e) }
    else
      object
    end
  end

  def self.ensure_cartridge_is_safe_to_run(cartridge_input, environment)
    components = {}

    if environment[:NANO_BOTS_CARTRIDGES_PATH]
      components[:ENV] = { 'NANO_BOTS_CARTRIDGES_PATH' => environment[:NANO_BOTS_CARTRIDGES_PATH] }
    end

    cartridge = if cartridge_input.is_a?(Hash)
                  cartridge_input
                else
                  found = NanoBot.cartridges.all(components:).find do |cartridge|
                    cartridge[:system][:id].to_s == cartridge_input.to_s
                  end

                  if found.nil? && cartridge_input.to_s.downcase.strip == 'default'
                    cartridge_input = '-'
                    found = NanoBot.cartridges.all(components:).find do |cartridge|
                      cartridge[:system][:id].to_s == cartridge_input.to_s
                    end
                  end

                  found
                end

    cartridge = SafetyLogic.symbolize_keys(cartridge)

    unless cartridge[:provider]
      cartridge[:provider] = SafetyLogic.symbolize_keys(
        YAML.safe_load_file('static/cartridges/default.yml', permitted_classes: [Symbol])['provider']
      )
    end

    cartridge[:safety] = {} if cartridge[:safety].nil?
    cartridge[:safety][:tools] = {} if cartridge[:safety][:tools].nil?
    cartridge[:safety][:functions] = {} if cartridge[:safety][:functions].nil?

    cartridge[:safety][:tools][:confirmable] = false

    cartridge[:safety][:functions][:sandboxed] = true if ENV.fetch('FORCE_SANDBOXED', nil).to_s == 'true'

    cartridge
  end
end
