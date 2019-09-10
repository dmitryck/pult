module Pult::Api

  API = Drawer

  def self.init! panel
    API.draw! panel

    API.add_swagger_documentation
  end

  def self.server! *args
    Server.run! *args, api: API
  end
end
