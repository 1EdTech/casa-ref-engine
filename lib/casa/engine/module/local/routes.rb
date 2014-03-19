require 'casa/engine/app'
require 'casa/publisher/strategy/all/sinatra'
require 'casa/publisher/strategy/one/sinatra'
require 'casa/publisher/strategy/search/sinatra'

module CASA
  module Engine
    class App

      namespace '/local' do

        make_options = Proc.new do
          {
            'from_handler' => settings.respond_to?(:local_payloads_index_handler) ? settings.local_payloads_index_handler : settings.local_payloads_handler,
            'postprocess_handler' => false
          }
        end

        # TODO: Refactor with more elegant CORS support

        allow_cors = {
          "Access-Control-Allow-Origin" => "*",
          "Access-Control-Allow-Methods" => "GET,POST",
          "Access-Control-Allow-Headers" => "Origin, X-Requested-With, Content-Type, Accept"
        }

        get '/payloads' do

          headers allow_cors
          CASA::Publisher::Strategy::All::Sinatra.new(self, make_options.call).execute

        end

        get '/payloads/:originator_id/:id' do

          headers allow_cors
          CASA::Publisher::Strategy::One::Sinatra.new(self, make_options.call).execute

        end

        get '/payloads/_:type' do

          headers allow_cors
          CASA::Publisher::Strategy::Search::Sinatra.new(self, make_options.call).execute

        end

        options '*' do

          headers allow_cors

        end

      end

    end
  end
end
