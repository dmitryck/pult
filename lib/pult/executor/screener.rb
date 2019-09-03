require 'open3'

class Pult::Executor::Screener

  attr_reader :runner

  def self.run! screen:, env:{}, params:{}, command:''
    screener = new(screen, env, params, command)
    screener.run!
    screener.runner
  end

  def initialize screen, env, params, command
    @screen   = screen
    @env      = env
    @params   = params
    @command  = command
  end

  def run!
    execute!
  end

  private

  def execute!
    command = "screen -S #{@screen} -p0 -X stuff \"#{@command}\015\""

    Open3.popen3( @params, command ) do |stdin, stdout, stderr, thr|
      # TODO for screen
      @runner = {
        stdout: stdout.read,
        stderr: stderr.read,
        info:   thr.value
      }
    end
  end

  def env
    # TODO
  end

  def params
    to_var @params
  end

  def to_var hash
    hash.each_with_object([]){|(k, v), o| o<<"#{k}='#{v}'" }.join(' ')
  end
end
