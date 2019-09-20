module Pult::Panel::Provider

  def self.files file, root
    root + '/**/' + file
  end
end
