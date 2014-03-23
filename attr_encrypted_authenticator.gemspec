# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attr_encrypted_authenticator/version'

Gem::Specification.new do |spec|
  spec.name          = "attr_encrypted_authenticator"
  spec.version       = AttrEncryptedAuthenticator::VERSION
  spec.authors       = ["junhanamaki"]
  spec.email         = ["jun.hanamaki@gmail.com"]
  spec.summary       = %q{authenticate attributes encrypted by attr_encrypted}
  spec.description   = %q{delegate type validation and convertion to model object, as one would normally do with rails}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "activesupport", ">= 3.0.0"
end
