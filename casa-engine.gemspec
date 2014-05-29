# coding: utf-8

Gem::Specification.new do |s|

  s.name        = 'casa-engine'
  s.version     = '0.1.0'
  s.summary     = 'Reference implementation of the CASA Engine'
  s.authors     = ['Eric Bollens']
  s.email       = ['ebollens@ucla.edu']
  s.homepage    = 'http://imsglobal.github.io/casa'
  s.license     = 'Apache-2.0'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'sinatra'
  s.add_dependency 'multi_json'
  s.add_dependency 'sequel'
  s.add_dependency 'casa-support'
  s.add_dependency 'casa-publisher'
  s.add_dependency 'casa-attribute'
  s.add_dependency 'casa-operation'
  s.add_dependency 'casa-receiver'
  s.add_dependency 'thor'
  s.add_dependency 'rufus-scheduler'
  s.add_dependency 'erubis'
  s.add_dependency 'elasticsearch'

  s.add_development_dependency 'rake'

end