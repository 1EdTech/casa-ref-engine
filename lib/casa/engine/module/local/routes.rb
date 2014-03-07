require 'casa/engine/app'
require 'casa/publisher/strategy/all/sinatra'
require 'casa/publisher/strategy/one/sinatra'

module CASA
  module Engine
    class App

      namespace '/local' do

        make_options = Proc.new do
          {
            'from_handler' => (settings.local_payloads_index_handler or settings.local_payloads_handler),
            'postprocess_handler' => false
          }
        end

        get '/payloads' do

          CASA::Publisher::Strategy::All::Sinatra.new(self, make_options.call).execute

        end

        get '/payloads/:originator_id/:id' do

          CASA::Publisher::Strategy::One::Sinatra.new(self, make_options.call).execute

        end

      end

    end
  end
end
