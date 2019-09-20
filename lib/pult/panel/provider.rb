module Pult::Panel::Provider

  #
  # here logic for multi or single app mode
  #
  def self.files file, root
    root + '/**/' + file
  end
end
