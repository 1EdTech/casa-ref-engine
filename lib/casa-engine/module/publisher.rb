require 'casa-publisher/app'

CASA::Publisher::App.set_storage_handler CASA::Engine::Persistence::AdjOutStore::SequelStorageHandler.new

CASA::Engine::Router.add({
  'class' => CASA::Publisher::App,
  'routes' => [
    { 'method' => :get, 'path' => '/payloads' }
  ]
})