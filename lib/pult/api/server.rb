module Pult::Api::Server

  PORT = ENV['PULT_API_PORT']&.to_i || 9292

  def self.run! api:, port: PORT
    Rack::Handler::WEBrick.run api, Port: port
  end
end
