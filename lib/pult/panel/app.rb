module Pult::Panel::App

  def self.config_dir! app_hash, path
    app_name = app_hash.keys.first

    dir = Pathname.new(path).dirname.to_s

    app_hash[app_name] = {} if ! app_hash[app_name]
    config = (app_hash[app_name]['config'] ||= {})

    config['dir'] ||= dir
  end

  def self.make_apps! panel
    panel.instance_variable_set(:@_apps, [])

    for app_name in panel.keys
      hash = panel[app_name]

      panel._apps << app_name

      to_app! hash, panel, app_name
    end
  end

  def self.to_app! app_hash, panel, app_name
    multi_action! app_hash

    app_hash.class_eval { include DotAccessible }

    Injector.inject! app_hash, panel, app_name

    app_hash.values.each do |target|
      to_app!(target, panel, app_name) if target.is_a?(Hash)
    end

    app_hash
  end

  def self.multi_action! app_hash
    app_hash.keys.each do |key|
      value = app_hash[key]

      case value.class.name

      when "Hash"
        multi_action! value

      when "Array"
        case Pult::MULTIACT

        when 'clone'
          clone app_hash
          complex = {}
          value.each{ |elm| complex[elm] = app_hash[elm] }
          app_hash[key] = complex

        when 'join'
          app_hash[key] = '$(' + value.join(') && $(') + ')'
        end
      end
    end
  end
end
