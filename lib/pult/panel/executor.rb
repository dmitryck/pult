module Pult::Panel::Executor

  # ActiveJob::Base
  class Job
    def perform hash_id, action, *args
      hash = ObjectSpace._id2ref hash_id
      Pult::Panel::Executor.run! hash, action, *args
    end
  end

  def self.run! hash, action, *args
    command = hash[action]

    runner = Pult::Executor.run! command, hash._config.dir, *args

    runner.class_eval { include Pult::Panel::DotAccessible::Basic }

    Pult::Panel::Injector::Runner.inject! hash, action, runner

    runner
  end

  def self.run_job! hash, action, *args
    Job.perform_later hash.object_id, action, *args
  end
end
