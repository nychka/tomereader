# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tomereader/version'

Gem::Specification.new do |spec|
  spec.name          = "tomereader"
  spec.version       = Tomereader::VERSION
  spec.authors       = ["nychka"]
  spec.email         = ["nychka93@gmail.com"]
  spec.summary       = %q{Tomereader will help you to read English books}
  spec.description   = %q{Tomereader will help you to learn English by reading your favourites books}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pdf-reader", "~>1.3"
  spec.add_development_dependency "rspec", "~>3.0"
  spec.add_development_dependency "logging"
  spec.add_development_dependency "em-synchrony"
  spec.add_development_dependency "tempfile"
end
