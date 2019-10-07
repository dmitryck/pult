module Pult

  FILE      = ENV['PULT_FILE']

  ROOT      = ENV['PULT_ROOT'] || Dir.pwd

  PORT      = ENV['PULT_PORT'] || 7070

  MULTIACT  = ENV['PULT_MULTIACT'] || 'join' # 'clone'

  RAKEPATH      = ENV['PULT_RAKEPATH']
  SERVICEPATH   = ENV['PULT_RAKEPATH']
end
