require 'disable_eval/railtie'

describe DisableEval::Railtie do
  should 'be inserted in the middleware stack in production' do
    ENV['RAILS_ENV'] = 'production'

    app = Class.new(Rails::Application)
    app.initialize!

    app.middleware.middlewares.first.should == DisableEval::Middleware
  end
end
