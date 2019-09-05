# Grape::API
class Pult::Api

  format :json

  Runner = Pult::Panel::Injector::Runner

  # hack for line 22
  @@self = self
  
  def self.panel
    @@panel
  end

  def self.init! panel
    @@panel = panel

    include Helper

    for app in @@panel._apps
      resource app do
        @@self.draw! app
      end
    end
  end

  def self.draw! app
    flat_app = @@panel[app]._to_flat.merge!(@@panel[app])

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
  end
end
