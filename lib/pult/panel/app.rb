module Pult::Panel::App

  def self.to_app! hash, panel, app
    multi_action! hash

    hash.class_eval { include DotAccessible }

    Injector.inject! hash, panel, app

    hash.values.each do |target|
      to_app!(target, panel, app) if target.is_a?(Hash)
    end

    hash
  end

  def self.multi_action! hash
    hash.keys.each do |key|
      value = hash[key]

      case value.class.name

      when "Hash"
        multi_action! value

      when "Array"
        case Pult::MULTIACT

        when 'clone'
          clone hash
          complex = {}
          value.each{ |elm| complex[elm] = hash[elm] }
          hash[key] = complex

        when 'join'
          hash[key] = '$(' + value.join(') && $(') + ')'
        end
      end
    end
  end
end
