# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jssh/version'

Gem::Specification.new do |spec|
  spec.name          = "jssh"
  spec.version       = Jssh::VERSION
  spec.authors       = ["qjpcpu"]
  spec.email         = ["qjpcpu@gmail.com"]
  spec.summary       = %q{Execute multiple ssh operation easily.}
  spec.description   = %q{Multiple ssh operations.}
  spec.homepage      = "https://github.com/qjpcpu/jssh"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "net-ssh"
end
