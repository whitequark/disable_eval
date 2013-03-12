require 'disable_eval/middleware'

describe DisableEval::Middleware do
  should 'call protect before passing request' do
    DisableEval.stubs(:protect!)

    app = lambda { |env|
      DisableEval.should.be.protected
      nil
    }

    middleware = DisableEval::Middleware.new(app)
    middleware.call({})
  end
end
