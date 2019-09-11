# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hps/version'

Gem::Specification.new do |spec|
  spec.name          = "hps"
  spec.version       = Hps::VERSION
  spec.authors       = ["Heartland Payment Systems"]
  spec.email         = ["IntegrationSupportTeam@e-hps.com"]
  spec.description   = %q{Ruby SDK for processing payments via Portico Gateway}
  spec.summary       = %q{Heartland Payment Systems - Portico Gateway SDK}
  spec.homepage      = ""
  spec.license       = "GPL-2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_dependency('builder', '>= 2.1.2')
  spec.add_dependency('activesupport', '>= 2.3.14')
end
