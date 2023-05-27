# frozen_string_literal: true

module IndexController
  def self.handler
    {
      project: 'Nano Bots API',
      version: '0.0.2',
      documentation: 'https://spec.nbots.io',
      'live-editor': 'https://clinic.nbots.io',
      github: 'https://github.com/icebaker/nano-bots-api'
    }
  end
end
