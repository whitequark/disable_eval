require 'disable_eval'

class DisableEval::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    DisableEval.protect

    @app.call(env)
  end
end
