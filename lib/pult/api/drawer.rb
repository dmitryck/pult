class Pult::Api::Drawer

  format :json

  ENV_VAR = /[A-Z][A-Z0-9]*/

  Runner = Pult::Panel::Injector::Runner

  @@self = self

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

  helpers do
    def path
      route.pattern.origin
    end

    def action_get
      /^\/(?<path>.+)$/ =~ path
      @@panel._apply_path!(path, params)
    end

    def action_post
      /^\/(?<path>.+)$/ =~ path
      @@panel._apply_path!("#{path}!", params)
    end
  end

  def self.draw! panel
    @@panel = panel

    for app in @@panel._apps

      resource app do

        flat_app = @@panel[app]._to_flat.merge!(@@panel[app])

        for action in flat_app._actions.sort.reverse
          action_url = action.gsub '.', '/'

          for injection in Runner.read_injections.sort
            @@self.info_get flat_app, action, injection
            get("#{action_url}_#{injection}") { action_get }
          end

          for injection in Runner.run_injections.sort
            @@self.info_post flat_app, action, injection
            post("#{action_url}_#{injection}") { action_post }
          end

          @@self.info_get flat_app, action
          get(action_url) { action_get }

          @@self.info_post flat_app, action
          post(action_url) { action_post }
        end

        for action in flat_app._actions.sort.reverse
          action_url = action.gsub '.', '/'

          @@self.info_post flat_app, action, job: true
          post("#{action_url}_job") { action_post }
        end
      end
    end
  end

  def self.info flat_app, action, injection, job, type:
    @@action = action
    @@action_title = flat_app._action_title(action)
    @@command = flat_app[action].to_s
    @@icon = job ? UI[:icon][:job] : UI[:icon][:run]
    @@injection = injection&.sub!('_', '') ? "#{injection}#{UI[:icon][:sep]}" : ''

    desc(UI[:title][type].call){ detail(UI[:detail][type].call) }

    parameters if type == :post
  end

  def self.parameters
    params do
      optional :screen, type: String

      @@command.scan(/(?<=\$)#{ENV_VAR}/).each do |param|
        description = { type: String }

        if ! (default = `echo -n $#{param}`).blank?
          description.merge! default: default
        end

        requires param.to_sym, description
      end
    end
  end

  def self.info_get flat_app, action, injection=nil, job: nil
    info flat_app, action, injection, job, type: :get
  end

  def self.info_post flat_app, action, injection=nil, job: nil
    info flat_app, action, injection, job, type: :post
  end
end
