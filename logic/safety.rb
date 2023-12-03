# frozen_string_literal: true

require 'yaml'

module SafetyLogic
  def self.ensure_cartridge_is_safe_to_run(cartridge_input)
    cartridge_input = '-' if cartridge_input == 'default'

    cartridge = if cartridge_input.is_a?(Hash)
                  cartridge_input
                else
                  NanoBot.cartridges.find do |cartridge|
                    cartridge[:system][:id].to_s == cartridge_input.to_s
                  end
                end

    cartridge.delete('safety')

    if !cartridge['provider'] && !cartridge[:provider]
      cartridge[:provider] =
        YAML.safe_load_file('static/cartridges/default.yml', permitted_classes: [Symbol])['provider']
    end

    cartridge[:safety] = {} if cartridge[:safety].nil?
    cartridge[:safety][:tools] = {} if cartridge[:safety][:tools].nil?
    cartridge[:safety][:functions] = {} if cartridge[:safety][:functions].nil?

    cartridge[:safety][:tools][:confirmable] = false

    cartridge[:safety][:functions][:sandboxed] = true

    cartridge
  end
end
