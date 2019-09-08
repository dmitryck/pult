module Pult::Api::Drawer::Helper

  def self.included base
    @@base = base

    Grape::API::Instance.extend ClassMethods

    base.helpers do
      def path
        route.pattern.origin
      end

      def panel
        @@base.class_variable_get :@@panel
      end

      def action route
        /^\/(?<path>.+)$/ =~ path.sub(/^\/#{@@base::PREFIX}/, '')
        panel._apply_path!(path, params)
      end

      def action! route
        /^\/(?<path>.+)$/ =~ path.sub(/^\/#{@@base::PREFIX}/, '')
        panel._apply_path!("#{path}!", params)
      end
    end
  end

  module ClassMethods
    UI = {
      red: ->(s){'<span style="color: red;">'+ s +'</span>'},
      icon: {
        job: '<b>&#8227; RUN JOB</b>',
        run: '<b>&#8227; RUN</b>',
        sep: ' | ',
      },
      title: {
        get:  ->{"#{@@injection}#{@@action_title}"},
        post: ->{"#{@@injection}#{@@action_title} #{@@icon}"},
      },
      detail: {
        get:  ->{"#{@@injection}#{@@action_title}<br>#{@@command}"},
        post: ->{"#{@@injection}#{@@action_title}<br>#{UI[:red].(@@command)}"}
      }
    }

    def info flat_app, action, injection, job, type:
      @@action = action
      @@action_title = flat_app._action_title(action)
      @@command = flat_app[action].to_s
      @@icon = job ? UI[:icon][:job] : UI[:icon][:run]
      @@injection = injection&.sub!('_', '') ? "#{injection}#{UI[:icon][:sep]}" : ''

      desc(UI[:title][type].call){ detail(UI[:detail][type].call) }

      parameters if type == :post
    end

    def parameters
      params do
        optional :screen, type: String

        @@command.scan(/(?<=\$)[^\s()]+/).each do |param|
          description = { type: String }

          if ! (default = `echo -n $#{param}`).blank?
            description.merge! default: default
          end

          requires param.to_sym, description
        end
      end
    end

    def info_get flat_app, action, injection=nil, job: nil
      info flat_app, action, injection, job, type: :get
    end

    def info_post flat_app, action, injection=nil, job: nil
      info flat_app, action, injection, job, type: :post
    end
  end
end
