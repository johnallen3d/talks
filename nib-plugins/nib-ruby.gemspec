lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nib/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'nib-ruby'
  spec.version       = Nib::Ruby::VERSION
  spec.authors       = ['John']
  spec.email         = ['john.allen@technekes.com']

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']
  spec.bindir        = 'bin'
  spec.executables   = ['nib-ruby']

  spec.add_runtime_dependency 'nib', '>= 2.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
