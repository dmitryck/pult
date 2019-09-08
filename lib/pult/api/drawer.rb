class Pult::Api::Drawer

  format :json

  PREFIX = ENV['PULT_API_PREFIX'] || 'api'

  prefix PREFIX

  def self.draw! panel
    @@panel = panel

    for @@app in @@panel._apps
      resource @@app, & ACTIONS
    end

    add_swagger_documentation
  end

  include Helper

  Runner = Pult::Panel::Injector::Runner

  ACTIONS = proc {

    flat_app = @@panel[@@app]._to_flat.merge!(@@panel[@@app])

    for action in flat_app._actions.sort.reverse
      action_url = action.gsub '.', '/'

      for injection in Runner.read_injections.sort
        info_get flat_app, action, injection
        get "#{action_url}_#{injection}" do
          action route
        end
      end

      for injection in Runner.run_injections.sort
        info_post flat_app, action, injection
        post "#{action_url}_#{injection}" do
          action route
        end
      end

      info_get flat_app, action
      get action_url do
        action route
      end

      info_post flat_app, action
      post action_url do
        action! route
      end
    end

    for action in flat_app._actions.sort.reverse
      action_url = action.gsub '.', '/'

      info_post flat_app, action, job: true
      post "#{action_url}_job" do
        action! route
      end
    end
  }
end
