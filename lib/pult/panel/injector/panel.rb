module Pult::Panel::Injector::Panel

  Runner = Pult::Panel::Injector::Runner

  def self.inject! panel
    panel.class_eval do
      attr_reader :_root
      attr_reader :_apps
    end

    panel.instance_eval do
      def panel?
        true
      end

      def _ui_apps order: :az
        resproc = proc { |app| [app, _app_title(app)] }
        tapps = _translated_apps

        case order
        when :az
          _apps.sort.map(&resproc)
        when :az_ui
          _actions.map(&resproc).sort_by{|arr| tapps.index(arr[1]) }
        end
      end

      def _translated_apps
        _apps.each { |app| _app_title(app) }
      end

      def _app_title app
        _app_translate(app) || app
      end

      def _app_translate app
        self[app].config&.ui&.ru&.title
      end

      def _apply_path path
        path.split('/').reduce(self, :[])
      end

      def _apply_path! path, params=nil
        params = params&.any? ? params : nil

        for postfix in _exec_flags + Runner.injections
          regexp = Regexp.new("\/([^\/]+" + Regexp.escape(postfix) + ")$")

          path.gsub!(regexp, '')

          return _apply_path(path).send(*[$1, params].compact) if $1
        end

        _apply_path(path)
      end

      def _exec_flags
        %w{ ! }
      end
    end
  end
end
