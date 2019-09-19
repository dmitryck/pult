class Pult::Panel

  include DotAccessible

  SYS_KEYS = %w{ config }

  attr_accessor :_root
  attr_accessor :_file

  def initialize auto: true
    @_root  = Pult::ROOT
    @_file  = Pult::FILE

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
    multi_action! hash

    hash.class_eval { include DotAccessible }

    Injector::App.inject! hash, panel, app

    hash.values.each do |target|
      app_hash!(target, panel, app) if target.is_a?(Hash)
    end

    hash
  end

  def self.multi_action! hash
    hash.keys.each do |key|
      value = hash[key]

      case value.class.name

      when "Hash"
        multi_action! value

      when "Array"
        case Pult::MULTIACT

        when 'clone'
          clone hash
          complex = {}
          value.each{ |elm| complex[elm] = hash[elm] }
          hash[key] = complex

        when 'join'
          hash[key] = '$(' + value.join(') && $(') + ')'
        end
      end
    end
  end

  private

  def allow_init?
    true_abs_path?(@_file) || (!!@_root && !!@_file)
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
    scan = @_root + '/**/' + @_file

    Dir[scan].each do |path|
      pult_file = YAML.load_file(path)

      dir! pult_file, path

      merge! pult_file
    end
  end

  def dir! hash, path
    app = hash.keys.first
    dir = Pathname.new(path).dirname.to_s

    config = (hash[app]['config'] ||= {})

    config['dir'] ||= dir
  end

  def app_hash! *args
    self.class.app_hash! *args
  end

  def multi_action! *args
    self.class.multi_action *args
  end
end
