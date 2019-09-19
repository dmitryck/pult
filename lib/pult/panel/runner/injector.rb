module Pult::Panel::Runner::Injector

  def self.injections
    read_injections + run_injections
  end

  def self.read_injections
    %w{ _out _in _err _suc _inf _act _pid }
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

      def #{action}_inf
        #{action}_runner.info
      end

      def #{action}_suc
        #{action}_inf.success?
      end

      def #{action}_pid
        #{action}_inf.pid
      end

      def #{action}_act

      end

      def #{action}_kill
        Pult::Executor::Terminator.kill! #{action}_pid
      end
    STR
  end
end
