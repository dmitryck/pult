module Pult::Executor::Enver

  # TODO
  DEFENV = ENV.to_h

  def with_env env=ENV.to_h, env_base=DEFENV
    env_delete_diff! env, env_base
    
    yield
    
    env_set_diff! env, env_base
  end

  def env_delete_diff! env, env_base
    env_diff(env, env_base).each do |var|
      ENV.delete(var)
    end
  end

  def env_set_diff! env, env_base
    env_diff(env, env_base).each do |var|
      ENV[var] = env[var]
    end
  end

  private

  def env_diff env, env_base
    env_base.keys - env.keys
  end
end
