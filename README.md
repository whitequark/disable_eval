# Disable Eval

The only safe eval is no eval.

This gem provides the method `DisableEval.protect`, which does the following:

  1. Undefines all builtin `eval` methods.
  2. Verifies that no one has aliased those methods to other names.

Note that it is not practically possible to eliminate every single way of evaluating code if you can arbitrary methods on arbitrary objects with arbitrary arguments. However, if you can do that, you don't need `eval`.

The gem also provides a Rack middleware `DisableEval::Middleware`, which removes `eval` before serving the very first request. This middleware is expected to run after all of the initialization code, which often calls `class_eval` and friends.

This gem should proactively protect you from remote code execution via [CVE-2013-0156][], [CVE-2013-0333][] and similar vulnerabilites. You can check if your application is protected with this [exploit][].

  [CVE-2013-0156]: https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/61bkgvnSGTQ
  [CVE-2013-0333]: https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/1h2DR63ViGo
  [exploit]: http://ronin-ruby.github.com/blog/2013/01/28/new-rails-poc.html

This gem will *not* protect you from SQL injections resulting from the aforementioned vulnerabilites.

## Installation

Add this line to your application's Gemfile:

    gem 'disable_eval'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install disable_eval

## Usage

Disable Eval includes a Rack middleware and a Railtie; if you include the gem in your Rails application, it will be activated automatically for all non-development environments.

If your application is not Rails-based, add this to the *top* of your `config.ru`:

``` ruby
use DisableEval::Middleware
```

It is important for the DisableEval middleware to be the first in the chain, as a middleware could contain a vulnerability. This was indeed the case in Rails.

## Issues

### Rails development

It is not realistically possible to protect an application running in a development environment with ActiveSupport-like code autoreloading enabled, as such an environment requires `eval` family to be accessible even after the first request has been served.

This feature can be used to conduct targeted attacks at developers by sending a cross-site request with a malicious payload to e.g. `localhost:3000`.

If code autoreloading is conducted via `fork` instead, such as with [shotgun][], `DisableEval` can be successfully used.

  [shotgun]: https://github.com/rtomayko/shotgun

### Aliasing

It is not realistically possible to verify that no live aliases to any `eval` functions exist, due to several reasons:

  1. While Ruby MRI provides full `ObjectSpace.each_object`, other Rubies don't; sophisticated code might capture a reference to an `UnboundMethod` of a `eval` function and reinstantiate it afterwards. Don't write such code.
  2. Even when it is possible to capture each reference potentially leading to an `eval` function, Ruby's reflection is not flexible enough to introspect them. For example, Pry captures `eval` in an anonymous Module, and that `eval` could not be trivially compared to `Kernel.instance_method(:eval)`, which it is.

Thus, alias verification is intended to serve as a sanity check and not a security measure by itself.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
