module Pult::Panel::Provider

  #
  # here logic for multi or single app mode
  #
  def self.files file, root
    root + '/**/' + file
  end

  def self.app_dirs panel
    arr = []
    panel.each{|app, h| arr << [app, h.dig(*%w{config dir})] }
    arr
  end
end
