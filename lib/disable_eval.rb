module DisableEval
  EVAL_METHODS = {
    RubyVM::InstructionSequence => [:eval],
    Binding                     => [:eval],
    Module                      => [:module_eval, :class_eval],
    BasicObject                 => [:instance_eval],
    Kernel                      => [:eval],
  }

  def self.verify!
    method_objs = EVAL_METHODS.map do |klass, methods|
      methods.map do |method|
        klass.instance_method(method)
      end
    end.flatten

    # Check that the eval methods are not redefined from their
    # original bodies. For builtin methods, #source_location returns `nil`.
    method_objs.each do |method_obj|
      if (loc = method_obj.source_location)
        raise SecurityError, "#{method_obj.owner}##{method_obj.name} was redefined in Ruby at #{loc.join(':')}"
      end
    end

    # Check that the method was not aliased under a different name.
    ObjectSpace.each_object(Module) do |target_klass|
      (target_klass.instance_methods +
       target_klass.private_instance_methods +
       target_klass.protected_instance_methods).each do |target_method|
        # We handle these.
        next if EVAL_METHODS.include?(target_klass) &&
                EVAL_METHODS[target_klass].include?(target_method)

        if method_objs.include?(target_klass.instance_method(target_method))
          raise SecurityError, "#{target_klass}##{target_method} is an aliased eval family method"
        end
      end
    end
  end

  def self.protect!
    EVAL_METHODS.each do |klass, methods|
      methods.each do |method|
        klass.send :remove_method, method
      end
    end
  end

  @protected = false

  def self.protect
    unless @protected
      verify!
      protect!

      @protected = true
    end
  end

  def self.protected?
    @protected
  end
end

require 'disable_eval/railtie' if defined?(Rails)
