# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "disable_eval"
  gem.version       = '0.1.0'
  gem.authors       = ["Peter Zotov"]
  gem.email         = ["whitequark@whitequark.org"]
  gem.description   = %q{The only safe eval is no eval.}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/whitequark/disable_eval"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 1.9'

  gem.add_development_dependency 'bacon'
  gem.add_development_dependency 'bacon-colored_output'
  gem.add_development_dependency 'mocha-on-bacon'
  gem.add_development_dependency 'rails'
  gem.add_development_dependency 'rake'
end
