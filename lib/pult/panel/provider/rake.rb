module Pult::Panel::Provider::Rake

  FILE    = 'Rakefile'
  COMMAND = %w{rake rails}

  PATH    = Pult::RAKEPATH || 'r'

  def self.mixin! panel
    app_dirs = Pult::Panel::Provider.app_dirs(panel)

    app_dirs.map{|a, d| [a, "#{d}/#{FILE}"] }.each do |app, rake_file|
      hash = pult_hash rake_file

      panel[app]&.merge! hash
    end
  end

  def self.pult_hash file
    hash  = {}

    maker = lambda do |task, command, count|
      n = -1
      task.split(':').reduce(hash) do |h, t|
        (n += 1) && n == count ? h[t] = "#{command} #{task}" : h[t] ||= {}
      end
    end

    for command in COMMAND
      tasks = self.tasks command, file

      for task in tasks.sort.reverse
        count = task.count(':')
        maker.(task, command, count)
      end

      break if hash.any?
    end

    { PATH => hash }
  end

  def self.tasks command, file
    app_dir = Pathname.new(file).dirname.to_s

    runner = Pult::Executor.run! "#{command} --tasks", app_dir

    tasks = runner[:stdout].split(/\n/).map do |s|
      s.sub(/^#{command} (\S+).*/, '\1')
    end

    # temp ignore params
    tasks.map{ |t| t.sub /\[.+/, '' }
  end
end
