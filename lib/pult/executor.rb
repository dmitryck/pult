class Pult::Executor

  # ActiveJob::Base
  class Job
    def perform *args
      Pult::Executor.run! *args
    end
  end

  include Enver

  attr_reader :runner

  NOEXEC = 'Нет запуска'

  def self.run! *args
    runner = Pult::Executor.new(*args)
    runner.run!
    runner.runner
  end

  def self.run_job! *args
    Job.perform_later(*args)
  end

  def initialize command, dir, params={}
    @command  = command
    @dir      = dir
    @params   = params.stringify_keys.transform_values {|v| v.to_s }

    @runner   = { info: NOEXEC }
  end

  def run!
    if @command && @dir && @params
      execute!
    end
  end

  private

  def execute!
    if screen = @params.delete("screen")
      execute_in_screen! screen
    else
      execute_here!
    end
  end

  def execute_here!
    params = [ @params, @command, chdir: @dir ]

    with_env do
      Open3.popen3( *params ) do |stdin, stdout, stderr, thr|
        @runner = {
          stdout: stdout.read,
          stderr: stderr.read,
          info:   thr.value
        }
      end
    end
  end

  def execute_in_screen! screen
    args = {
      screen:   screen,
      env:      ENV_DEFAULT,
      params:   @params,
      command:  @command
    }

    @runner = Screener.run! args
  end
end
