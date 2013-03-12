require 'disable_eval/middleware'
require 'rails'

class DisableEval::Railtie < Rails::Railtie
  initializer "disable_eval.configure_rails_initialization" do |app|
    if Rails.env.production?
      app.middleware.insert 0, DisableEval::Middleware
    end
  end
end
