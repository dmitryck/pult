module Pult
  class Error < StandardError; end

  class Cli; end

  module Api 
    class Drawer < Grape::API
      module Helper; end
    end
    module Server; end
  end

  class Executor
    module Enver; end
    class Job < ActiveJob::Base; end
    class  Screener; end
    class  Terminator; end
  end

  class Panel < Hash
    module DotAccessible; end
    module Executor
      class Job < ActiveJob::Base; end
    end
    module Injector
      module App; end
      module Panel; end
      module Runner; end
    end
  end
end
