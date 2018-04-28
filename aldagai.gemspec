# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "aldagai/version"

Gem::Specification.new do |spec|
  spec.name          = "aldagai"
  spec.version       = Aldagai::VERSION
  spec.authors       = ["Pablo Ifran"]
  spec.email         = ["pabloifran@gmail.com"]

  spec.summary       = "Promote environment variables on heroku"
  spec.description   = 'Make zero downtime deployments easier allowing developers to promote environment variables'
  spec.homepage      = 'https://github.com/elpic/aldagai'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
