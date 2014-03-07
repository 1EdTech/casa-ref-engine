require 'casa/engine/app'
require 'casa/publisher/strategy/sinatra'

module CASA
  module Engine
    class App

      namespace '/local' do

        get '/payloads' do

          options = {
            'from_handler' => (settings.local_payloads_index_handler or settings.local_payloads_handler),
            'postprocess_handler' => false
          }

          CASA::Publisher::Strategy::Sinatra.new(self, options).execute

        end

      end

    end
  end
end
