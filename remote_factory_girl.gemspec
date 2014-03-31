# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remote_factory_girl/version'

Gem::Specification.new do |spec|
  spec.name          = "remote_factory_girl"
  spec.version       = RemoteFactoryGirl::VERSION
  spec.authors       = ["tdouce"]
  spec.email         = ["travisdouce@gmail.com"]
  spec.summary       = %q{ Create factories in server from client. }
  spec.description   = %q{ Faciliates SOA (software oriented architecture) integration testing. Create objects from client in home. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
