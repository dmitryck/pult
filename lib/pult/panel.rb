class Pult::Panel

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
      to_panel!
    else
      raise StandardError, 'Init is not allowed!'
    end
  end

  private

  def allow_init?
    true_abs_path?(@_file) || (!!@_root && !!@_file)
  end

  def true_abs_path? path
    path[0] == '/' && File.exists(path)
  end

  def to_panel!
    compile_from_pult_files!

    class_eval { include DotAccessible }

    Injector.inject! self

    make_apps!
  end

  def make_apps!
    @_apps = []

    for app_name in keys
      app = self[app_name]

      @_apps << app_name

      App.to_app! app, self, app_name
    end
  end

  def compile_from_pult_files!
    scan = @_root + '/**/' + @_file

    Dir[scan].each do |pult_file|
      pult_hash = YAML.load_file(pult_file)

      dir! pult_hash, pult_file

      merge! pult_hash
    end
  end

  def dir! hash, path
    app = hash.keys.first
    dir = Pathname.new(path).dirname.to_s

    config = (hash[app]['config'] ||= {})

    config['dir'] ||= dir
  end
end
