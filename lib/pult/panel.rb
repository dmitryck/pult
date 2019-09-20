class Pult::Panel

  SYS_KEYS = %w{ config }

  attr_accessor :_root
  attr_accessor :_file

  def initialize auto: true
    @_file  = Provider::Pult::FILE
    @_root  = Pult::ROOT

    init! if auto && allow_init?
  end

  def init!
    allow_init? ? \
      to_panel! : raise(StandardError, 'Init is not allowed!')
  end

  private

  def to_panel!
    class_eval { include DotAccessible }

    Provider::Pult.mixin! self

    Injector.inject! self

    App.make_apps! self
  end

  def allow_init?
    true_abs_path?(@_file) || (!!@_root && !!@_file)
  end

  def true_abs_path? path
    path[0] == '/' && File.exists(path)
  end
end
