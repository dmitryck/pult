module Pult::Panel::Provider::Service

  PATH    = Pult::SERVICEPATH || 's'

  COMMAND = 'service'
  ACTIONS = %w{start restart stop status}

  def self.mixin! panel
    hash = pult_hash panel

    Pult::Panel::App.config_dir! hash, Dir.pwd

    panel.merge! hash
  end

  def self.pult_hash panel
    hash = {}

    for service in services
      hash[service] = {}

      for action in ACTIONS
        hash[service][action] = "#{COMMAND} #{service} #{action}"
      end
    end

    { PATH => hash }
  end

  def self.services
    runner = Pult::Executor.run! "#{COMMAND} --status-all", Dir.pwd

    runner[:stdout].scan(/[a-z][a-z\.0-9-_]+/)
  end
end
