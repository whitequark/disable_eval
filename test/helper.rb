require 'bacon'
require 'bacon/colored_output'
require 'mocha-on-bacon'

require 'disable_eval'
require 'disable_eval/middleware'

module TestDisableEval
  # Tests really *need* various evals.
  def self.with_locally_saved_eval
    instance_eval = BasicObject.instance_method(:instance_eval)
    module_eval   = Module.instance_method(:module_eval)
    binding_eval  = Binding.instance_method(:eval)
    kernel_eval   = Kernel.instance_method(:eval)

    yield
  ensure
    BasicObject.send :define_method, :instance_eval, instance_eval
    Module.send :define_method, :module_eval, module_eval
    Module.send :define_method, :class_eval, module_eval
    Binding.send :define_method, :eval, binding_eval
    Kernel.send :define_method, :eval, kernel_eval
  end
end

module DisableEval
  class << self
    # We should have a way to restore pre-mock state.
    alias original_protect! protect!

    def restore_state!
      alias protect! original_protect!
      @protected = false
    end
  end
end
