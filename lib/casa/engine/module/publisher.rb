require 'casa/publisher/app'
require 'casa/relay/strategy/convert_payload'

module CASA
  module Engine
    class App

      configure do

        CASA::Publisher::App.set_storage_handler CASA::Engine::Persistence::AdjOutPayloads::SequelStorageHandler.new

        CASA::Publisher::App.set_postprocess_handler CASA::Relay::Strategy::ConvertPayload.new

        CASA::Engine::Router.add({
          'class' => CASA::Publisher::App,
          'routes' => [
            { 'method' => :get, 'path' => '/payloads' }
          ]
        })

      end

    end
  end
end
