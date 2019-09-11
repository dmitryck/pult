module Pult::Api::Server

  PORT = ENV['PULT_API_PORT']&.to_i || 9292

  # temp fix curl -d ''
  METHS = WEBrick::HTTPRequest::BODY_CONTAINABLE_METHODS
  WEBrick::HTTPRequest::BODY_CONTAINABLE_METHODS = METHS - ['POST']

  def self.run! api:, port: PORT
    Rack::Handler::WEBrick.run api, Port: port
  end
end
