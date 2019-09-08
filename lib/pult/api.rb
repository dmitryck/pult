module Pult::Api

  def self.init! panel
    Drawer.draw! panel
  end

  def self.server! *args
    Server.run! *args, api: Drawer
  end
end
