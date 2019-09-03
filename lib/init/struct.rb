module Pult
  class Executor
    class Job < ActiveJob::Base; end
    module Enver; end
    class  Screener; end
    class  Terminator; end
  end

  class Panel < Hash
    module Executor
      class Job < ActiveJob::Base; end
    end
    module DotAccessible; end
    module Injector
      module App; end
      module Panel; end
      module Runner; end
    end
  end
end
