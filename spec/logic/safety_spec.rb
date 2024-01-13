# frozen_string_literal: true

require './logic/safety'

RSpec.describe SafetyLogic do
  it 'makes cartridge safe to run' do
    ENV['FORCE_SANDBOXED'] = 'false'
    expect(SafetyLogic.ensure_cartridge_is_safe_to_run({}, {})[:safety][:tools][:confirmable]).to eq(false)
    expect(SafetyLogic.ensure_cartridge_is_safe_to_run({}, {})[:safety][:functions][:sandboxed]).to eq(nil)
    expect(SafetyLogic.ensure_cartridge_is_safe_to_run({}, {})[:provider]).not_to be_nil

    ENV['FORCE_SANDBOXED'] = 'true'
    expect(SafetyLogic.ensure_cartridge_is_safe_to_run({}, {})[:safety][:tools][:confirmable]).to eq(false)
    expect(SafetyLogic.ensure_cartridge_is_safe_to_run({}, {})[:safety][:functions][:sandboxed]).to eq(true)
    expect(SafetyLogic.ensure_cartridge_is_safe_to_run({}, {})[:provider]).not_to be_nil
  end
end
