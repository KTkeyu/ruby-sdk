Gem::Specification.new do |s|
    s.name        = 'statsig'
    s.version     = '0.0.0'
    s.summary     = 'Statsig server SDK for Ruby'
    s.description = 'Statsig server SDK for feature gates and experimentation in Ruby'
    s.authors     = ['Statsig, Inc']
    s.email       = 'support@statsig.com'
    s.homepage    =
    'https://rubygems.org/gems/statsig'
    s.license       = 'ISC'

    s.files       = ['lib/statsig.rb', 'lib/network.rb']
    s.add_development_dependency 'concurrent-ruby'
    s.add_development_dependency 'http'
    s.add_runtime_dependency 'concurrent-ruby'
    s.add_runtime_dependency 'http'
  end