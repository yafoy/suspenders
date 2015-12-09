# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yastart/version'

Gem::Specification.new do |spec|
  spec.name          = "yastart"
  spec.version       = Yastart::VERSION
  spec.authors       = ["Olivier"]
  spec.email         = ["olivier@yafoy.com"]

  spec.summary       = "yastart is the base Rails application used at yafoy"
  spec.description   = "Bootstrap new Rails project with a set of templates"
  spec.homepage      = "https://github.com/yafoy/yastart"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #spec.bindir        = "exe"
  #spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.executables = ['yastart']

  spec.add_dependency 'bitters', '~> 1.1.0'
  spec.add_dependency 'rails', Yastart::RAILS_VERSION

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
