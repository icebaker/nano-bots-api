# frozen_string_literal: true

module SafetyLogic
  def self.ensure_cartridge_is_safe_to_run(cartridge_input)
    cartridge = if cartridge_input.is_a?(Hash)
                  cartridge_input
                else
                  NanoBot.cartridges.find do |cartridge|
                    cartridge[:system][:id].to_s == cartridge_input.to_s
                  end
                end

    cartridge.delete('safety')

    cartridge[:safety] = {} if cartridge[:safety].nil?
    cartridge[:safety][:tools] = {} if cartridge[:safety][:tools].nil?
    cartridge[:safety][:functions] = {} if cartridge[:safety][:functions].nil?

    cartridge[:safety][:tools][:confirmable] = false

    cartridge[:safety][:functions][:sandboxed] = true

    cartridge
  end
end
