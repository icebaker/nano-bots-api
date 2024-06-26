# frozen_string_literal: true

require 'nano-bots'

API = {
  project: 'Nano Bots API',
  version: '1.9.0',
  'nano-bots': { version: NanoBot.version, specification: NanoBot.specification },
  documentation: 'https://spec.nbots.io',
  'live-editor': 'https://clinic.nbots.io',
  github: 'https://github.com/icebaker/nano-bots-api',
  plugins: [
    'https://github.com/icebaker/obsidian-nano-bots',
    'https://github.com/icebaker/sublime-nano-bots',
    'https://github.com/icebaker/vscode-nano-bots'
  ]
}.freeze
