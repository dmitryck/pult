module Pult::Panel::Provider::Pult

  FILE = Pult::FILE || '.pult.yml'

  def self.mixin! panel
    pult_files = Pult::Panel::Provider.files(panel._file, panel._root)

    Dir[pult_files].each do |pult_file|

      hash = pult_hash pult_file

      Pult::Panel::App.config_dir! hash, pult_file

      panel.merge! hash
    end
  end

  def self.pult_hash file
    YAML.load_file(file)
  end
end
