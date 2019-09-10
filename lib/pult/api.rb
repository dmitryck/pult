module Pult::Api

  def self.init! panel
    Drawer.draw! panel

    Drawer.add_swagger_documentation
  end

  def self.server! *args
    Server.run! *args, api: Drawer
  end
end
