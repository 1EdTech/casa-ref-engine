require 'casa/engine/app'
require 'casa/engine/app/handle_with'
require 'casa/publisher/app'
require 'casa/relay/strategy/convert_payload'

module CASA
  module Engine
    class App

      namespace '/out' do

        get '/payloads' do

          handle_publish_with({
            'from_handler' => CASA::Engine::Persistence::AdjOutPayloads::SequelStorageHandler.new,
            'postprocess_handler' => CASA::Relay::Strategy::ConvertPayload.new
          })

        end

      end

    end
  end
end
