module Pult::Panel::DotAccessible

  Runner = Pult::Panel::Injector::Runner

  JOB_KEY = '_job'

  module Basic
    def method_missing meth, *args
      self[meth]
    end
  end

  class Job < ActiveJob::Base
    def perform block_id
      ObjectSpace._id2ref(block_id).call
    end
  end

  def method_missing meth, *args
    /(?<action>[^\!]+)(?<need_execute>\!?)/ =~ meth.to_s

    for injection in [JOB_KEY] + Runner.read_injections
      action.gsub! /#{injection}$/, ''
      break if $&
    end

    value = self[action]

    if !need_execute.blank?
      if value.respond_to? :app?
        with_job? $& do
          for sub_action in value.keys
            value.send "#{sub_action}!", *args
          end
        end
      else
        return execute!(action, $&, *args)
      end
    end

    $& ? nil : value
  end

  private

  def with_job? injection, &block
    job?(injection) ? Job.perform_later(block.object_id) : block.call
  end

  def execute! action, injection=nil, *args
    job = job?(injection) ? injection : nil

    runner = Pult::Panel::Executor.send "run#{job}!", self, action, *args

    if injection && !job
      return send("#{action}#{injection}")
    else
      return runner
    end
  end

  def job? str
    str == JOB_KEY
  end
end
