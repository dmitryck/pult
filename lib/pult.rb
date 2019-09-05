require_relative 'init/boot'

module Pult
  class Error < StandardError; end

  def self.new *args
    Panel.new *args
  end
end
