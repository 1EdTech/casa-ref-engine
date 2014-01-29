require 'casa/engine/app'
require 'casa/engine/app/configure_route'
require 'casa/publisher/app'
require 'casa/relay/strategy/convert_payload'

module CASA
  module Engine
    class App

      CASA::Publisher::App.set_storage_handler CASA::Engine::Persistence::AdjOutPayloads::SequelStorageHandler.new
      CASA::Publisher::App.set_postprocess_handler CASA::Relay::Strategy::ConvertPayload.new

      configure_route CASA::Publisher::App, 'method' => :get, 'path' => '/payloads'

    end
  end
end
