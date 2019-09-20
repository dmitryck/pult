module Pult
  class Error < StandardError; end

  class Cli; end

  module Api 
    class Drawer < Grape::API; end
    module Server; end
  end

  class Executor
    module Enver; end
    class Job < ActiveJob::Base; end
    class  Screener; end
    class  Terminator; end
  end

  class Panel < Hash
    module Provider
      module Pult; end
    end
    module App
      module DotAccessible; end
      module Injector; end
    end
    module Runner
      module DotAccessible; end
      module Injector; end
    end
    module DotAccessible; end
    module Injector; end
    module Executor
      class Job < ActiveJob::Base; end
    end
  end
end
