require_relative 'init/boot'

module Pult

  def self.new *args
    Panel.new *args
  end
end
