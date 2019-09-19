module Pult

  ROOT     = ENV['PULT_ROOT'] || Dir.pwd
  FILE     = ENV['PULT_FILE'] || '.pult.yml'
  PORT     = ENV['PULT_PORT'] || 7070
end
