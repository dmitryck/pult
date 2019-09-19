module Pult::Api::Server

  # temp fix curl -d ''
  METHS = WEBrick::HTTPRequest::BODY_CONTAINABLE_METHODS
  WEBrick::HTTPRequest::BODY_CONTAINABLE_METHODS = METHS - ['POST']

  def self.run! api:, port: Pult::PORT
    Rack::Handler::WEBrick.run api, Port: port
  end
end
