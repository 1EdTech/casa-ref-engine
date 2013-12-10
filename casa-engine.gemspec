Gem::Specification.new do |s|

  s.name        = 'casa-engine'
  s.version     = '0.0.01'
  s.summary     = 'Reference implementation of the CASA Engine'
  s.authors     = ['Eric Bollens']
  s.email       = ['ebollens@ucla.edu']
  s.homepage    = 'https://appsharing.github.io/casa-protocol'
  s.license     = 'BSD-3-Clause'

  s.files       = ['lib/casa-engine.rb']

  s.add_dependency 'sinatra'
  s.add_dependency 'multi_json'
  s.add_dependency 'sequel'
  s.add_dependency 'casa-publisher'
  s.add_dependency 'thor'

  s.add_development_dependency 'rake'

end