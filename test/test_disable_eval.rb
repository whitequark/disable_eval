describe DisableEval do
  before do
    DisableEval.restore_state!
  end

  should 'call protect! only once when protect is called' do
    DisableEval.expects(:protect!).times(1)

    DisableEval.protect
    DisableEval.protect
  end

  should 'report the state with protected?' do
    DisableEval.stubs(:protect!)

    DisableEval.protected?.should.be.false
    DisableEval.protect
    DisableEval.protected?.should.be.true
  end

  should 'verify if eval is aliased' do
    DisableEval.stubs(:protect!)

    begin
      Module.class_exec do
        alias foo_eval class_eval
      end
      Module.foo_eval('2').should == 2

      -> {
        DisableEval.protect
      }.should.raise(SecurityError, %r|aliased|)
    ensure
      Module.class_exec do
        undef foo_eval
      end
    end
  end

  should 'verify if eval is redefined' do
    DisableEval.stubs(:protect!)

    begin
      Module.class_exec do
        alias old_class_eval class_eval

        def class_eval(*)
          # do nothing
        end
      end
      Module.class_eval('2').should == nil

      -> {
        DisableEval.protect
      }.should.raise(SecurityError, %r|redefined|)
    ensure
      # Restore.
      Module.class_exec do
        alias class_eval old_class_eval
        undef old_class_eval
      end
    end
  end

  should 'disable eval' do
    eval('1').should == 1

    TestDisableEval.with_locally_saved_eval do
      DisableEval.protect

      lambda {
        eval('1')
      }.should.raise(NoMethodError)
    end
  end
end
