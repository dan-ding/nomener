# encoding: UTF-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nomener/version'

Gem::Specification.new do |spec|
  spec.name          = "nomener"
  spec.version       = Nomener::VERSION
  spec.authors       = ["Dante Piombino"]
  spec.email         = ["not@amusing.ninja"]
  spec.summary       = %q{A(nother)? human name parser in ruby.}
  spec.description   = %q{A human name parser in ruby. It attempts to determine name pieces like title, first name, surname, etc. }
  spec.homepage      = "https://github.com/dan-ding/nomener"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  rv = RUBY_VERSION.split(".")[(0..1)].join("")
  if rv >= '19' && rv < '21'
    spec.add_runtime_dependency "string-scrub", ">= 0.0.5"
  end

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake",  "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "simplecov", "~> 0.9"
end
