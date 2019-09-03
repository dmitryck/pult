module Pult::Panel::Injector::Runner

  def self.injections
    read_injections + run_injections
  end

  def self.read_injections
    %w{ _out _in _err _success _info _active _pid }
  end

  def self.run_injections
    %w{ _kill }
  end

  def self.inject! hash, action, runner
    #
    # TODO runner meths and sys maybe need list
    # for safe using with ! and other
    #
    hash.instance_eval do
      def runner?
        true
      end
    end

    hash.instance_eval <<-STR
      def #{action}_runner
        ->{ ObjectSpace._id2ref(#{runner.object_id}) }.call
      end

      def #{action}_out
        #{action}_runner.stdout
      end

      def #{action}_err
        #{action}_runner.stderr
      end

      def #{action}_info
        #{action}_runner.info
      end

      def #{action}_success
        #{action}_info.success?
      end

      def #{action}_pid
        #{action}_info.pid
      end

      def #{action}_active

      end

      def #{action}_kill
        Pult::Executor::Terminator.kill! #{action}_pid
      end
    STR
  end
end
