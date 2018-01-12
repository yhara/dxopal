# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'opal/dxopal/version.rb'

Gem::Specification.new do |spec|
  spec.name          = "dxopal"
  spec.version       = DXOpal::VERSION
  spec.authors       = ["Yutaka HARA"]
  spec.email         = ["yutaka.hara+github@gmail.com"]

  spec.summary       = %q{Game development framework for Opal}
  spec.homepage      = "https://github.com/yhara/dxopal"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(examples|vendor|test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "opal", "~> 0.11.0"
  spec.add_runtime_dependency "thor", "~> 0.19.1"
  spec.add_runtime_dependency "rack", "~> 2.0"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "yard", "~> 0.9.12"
  spec.add_development_dependency "opal-sprockets", "~> 0.4.1"
end
