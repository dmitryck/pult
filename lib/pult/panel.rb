class Pult::Panel

  include DotAccessible

  CONFIG_ROOT  = ENV['PULT_CONFIG_ROOT'] || nil
  CONFIG_FILE  = ENV['PULT_CONFIG_FILE'] || 'pult.yml'

  SYS_KEYS = %w{ config }

  attr_accessor :_config_root
  attr_accessor :_config_file

  def initialize auto: true
    @_config_root  = CONFIG_ROOT
    @_config_file  = CONFIG_FILE

    init! if auto && allow_init?
  end

  def init!
    if allow_init?

      panel_hash!
    else
      raise StandardError, 'Init is not allowed!'
    end
  end

  def self.app_hash! hash, panel, app
    array_node! hash

    hash.class_eval { include DotAccessible }

    Injector::App.inject! hash, panel, app

    hash.values.each do |target|
      app_hash!(target, panel, app) if target.is_a?(Hash)
    end

    hash
  end

  def self.array_node! hash
    hash.keys.each do |key|
      value = hash[key]

      case value.class.name
      when "Hash" then array_node! value
      when "Array"
        # clone hash
        # complex = {}
        # value.each{ |elm| complex[elm] = hash[elm] }
        # hash[key] = complex

        # combine commands
        hash[key] = '$(' + value.join(') && $(') + ')'
      end
    end
  end

  private

  def allow_init?
    true_abs_path?(@_config_file) || (!!@_config_root && !!@_config_file)
  end

  def true_abs_path? path
    path[0] == '/' && File.exists(path)
  end

  def panel_hash!
    compile_hash_from_configs!

    @_apps = []

    for app_name in keys
      app = self[app_name]
      @_apps << app_name

      app_hash! app, self, app_name
    end

    class_eval { include DotAccessible }

    Injector::Panel.inject! self
  end

  def compile_hash_from_configs!
    scan = @_config_root + '/**/' + @_config_file

    Dir[scan].each do |path|
      config_file = YAML.load_file(path)

      merge! config_file
    end
  end

  def app_hash! *args
    self.class.app_hash! *args
  end

  def array_node! *args
    self.class.array_node *args
  end
end
