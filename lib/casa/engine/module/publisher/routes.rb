require 'casa/engine/app'
require 'casa/publisher/strategy/sinatra'
require 'casa/relay/strategy/convert_payload'

module CASA
  module Engine
    class App

      namespace '/out' do

        get '/payloads' do

          options = {
            'from_handler' => settings.adj_out_payloads_handler,
            'postprocess_handler' => CASA::Relay::Strategy::ConvertPayload.new
          }

          CASA::Publisher::Strategy::Sinatra.new(self, options).execute

        end

      end

    end
  end
end
