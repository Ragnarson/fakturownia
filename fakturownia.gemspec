# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fakturownia/version'

Gem::Specification.new do |spec|
  spec.name          = "fakturownia_api"
  spec.version       = Fakturownia::VERSION
  spec.authors       = ["Shelly Cloud team"]
  spec.email         = ["devs@shellycloud.com"]
  spec.summary       = %q{Ruby API for invoicing service fakturownia.pl}
  spec.description   = %q{Ruby API for invoicing service Fakturownia. Pay attention, it is an informal wrapper.}
  spec.homepage      = "https://github.com/shellycloud/fakturownia"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client", '~> 1.7'
  spec.add_runtime_dependency "activesupport", '~> 4.1'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "fakeweb", '~> 1.3'
  spec.add_development_dependency 'webmock', '~> 1.2'
  spec.add_development_dependency "rspec", "~> 3.1"
end
