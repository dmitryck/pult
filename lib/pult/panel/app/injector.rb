module Pult::Panel::App::Injector

  SYS_KEYS = Pult::Panel::SYS_KEYS

  def self.inject! hash, panel, app
    hash.instance_eval <<-STR
      def _app
        "#{app}"
      end

      def _panel
        ->{ ObjectSpace._id2ref(#{panel.object_id}) }.call
      end
    STR
  
    hash.instance_eval do
      def app?
        true
      end

      def _to_flat param=self, prefix=nil
        hash = param.each_pair.reduce({}) do |a, (k, v)|
          v.is_a?(Hash) && ! SYS_KEYS.include?(k) ?
            a.merge(_to_flat(v, "#{prefix}#{k}."))
            : a.merge("#{prefix}#{k}" => v)
        end

        Pult::Panel::App.to_app! hash, _panel, _app
      end

      def _config
        _panel[_app].config
      end

      def _actions
        keys - SYS_KEYS
      end

      def _translated_actions
        _actions.map{ |action| _action_title(action) }
      end

      #
      # TODO order param like :ui => :az, :orig => :config, etc..
      #
      def _ui_actions order: :az_ui
        resproc = proc { |action| [action, _action_title(action)] }
        tacts = _translated_actions

        case order
        when :config
          _actions.map(&resproc)
        when :config_ui
          _actions.map(&resproc).sort_by{|arr| tacts.index(arr[1]) }
        when :az
          _actions.sort.map(&resproc)
        when :az_ui
          _actions.map(&resproc).sort_by{|arr| arr[1] }
        end
      end

      def _action_title action
         _action_translate(action) || action
      end

      def _action_translate action
        self&.config&.ui&.ru&.action&.send(:[], action)
      end
    end
  end
end
