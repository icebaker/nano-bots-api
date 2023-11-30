# frozen_string_literal: true

require './logic/safety'

RSpec.describe SafetyLogic do
  it 'makes cartridge safe to run' do
    expect(SafetyLogic.ensure_cartridge_is_safe_to_run({})[:safety][:confirmable]).to eq(false)
  end
end