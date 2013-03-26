# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aba_numbers/version'

Gem::Specification.new do |gem|
  gem.name          = 'aba_numbers'
  gem.version       = AbaNumbers::VERSION
  gem.authors       = ['Adrian Madrid']
  gem.email         = %w(aemadrid@gmail.com)
  gem.description   = %q{Get a list of Federal Reserve E-Payments Routing Directory}
  gem.summary       = %q{Get a list of Federal Reserve E-Payments Routing Directory from the Federal Reserve Financial Services}
  gem.homepage      = 'https://github.com/NorthPointAdvisors/aba_numbers'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w( lib )

  gem.add_development_dependency 'rspec', '~> 2.8.0'
  gem.add_development_dependency 'simplecov', '~> 0.7.1'
end
