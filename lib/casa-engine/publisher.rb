require 'casa-publisher/app'

CASA::Engine::Router.add({
  'class' => CASA::Publisher::App,
  'routes' => [
    { 'method' => :get, 'path' => '/payloads' }
  ]
})