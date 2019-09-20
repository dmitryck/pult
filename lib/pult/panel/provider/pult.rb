module Pult::Panel::Provider::Pult

  FILE = Pult::FILE || '.pult.yml'

  def self.mixin! panel
    pult_files = panel._root + '/**/' + panel._file

    Dir[pult_files].each do |pult_file|

      pult_hash = YAML.load_file(pult_file)

      Pult::Panel::App.config_dir! pult_hash, pult_file

      panel.merge! pult_hash
    end
  end
end
