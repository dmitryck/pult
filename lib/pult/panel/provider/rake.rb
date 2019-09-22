module Pult::Panel::Provider::Rake

  FILE    = 'Rakefile'
  COMMAND = 'rake'

  PATH    = Pult::RAKEPATH || 'r'

  def self.mixin! panel
    rake_files = Pult::Panel::Provider.files(FILE, panel._root)

    Dir[rake_files].each do |rake_file|

      hash = pult_hash rake_file

      Pult::Panel::App.config_dir! hash, rake_file

      panel.merge! hash
    end
  end

  def self.pult_hash file
    hash  = {}
    tasks = self.tasks(file)

    for task in tasks
      count = task.count(':')

      n = -1
      task.split(':').reduce(hash) do |h, t|
        (n += 1) && n == count ? h[t] = "#{COMMAND} #{task}" : h[t] = {}
      end
    end

    { PATH => hash }
  end

  def self.tasks file
    app_dir = Pathname.new(file).dirname.to_s

    runner = Pult::Executor.run! "#{COMMAND} --tasks", app_dir

    tasks = runner[:stdout].split(/\n/).map do |s|
      s.sub(/^#{COMMAND} (\S+).*/, '\1')
    end

    # temp ignore params
    tasks.map{ |t| t.sub /\[.+/, '' }
  end
end
