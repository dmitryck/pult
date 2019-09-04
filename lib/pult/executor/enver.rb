module Pult::Executor::Enver

  CURRENT = ENV.to_h

  ENVS = ENV['PULT_ENV_DEFAULT'] || ENV['PULT_ENV_BASE']

  ENV_BASE = !!ENV['PULT_ENV_BASE']

  DEFAULT_VARS = ENVS&.split(/=.+?"?\n/)

  DEFAULT = DEFAULT_VARS ?
    CURRENT.select{|k, v| DEFAULT_VARS.include?(k) } : CURRENT

  RESOLVER = {
    default: DEFAULT,
    current: CURRENT
  }

  def with_env resolver_or_env
    env = RESOLVER[resolver_or_env] || resolver_or_env
    
    if env.is_a?(Hash)
      ENV_BASE ? env_set!(env) : env_set(env)
      
      yield
      
      env_set!(CURRENT)
    else
      raise ArgumentError, 'Env not resolved'
    end
  end

  private

  def env_set env
    ENV.keys.each do |var|
      ENV[var] = env[var] if env[var]
    end
  end

  def env_set! env
    ENV.keys.each do |var|
      env[var] ? ENV[var] = env[var] : ENV.delete(var)
    end
  end

  def env_delete_diff! env1, env2
    diff(env1, env2).each do |var|
      ENV.delete(var)
    end
  end

  def env_set_diff! env1, env2
    diff(env1, env2).each do |var|
      ENV[var] = env[var]
    end
  end

  def diff env1, env2
    env2.keys - env1.keys
  end
end
