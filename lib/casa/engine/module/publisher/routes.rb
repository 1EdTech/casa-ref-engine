require 'casa/engine/app'
require 'casa/publisher/strategy/sinatra'
require 'casa/engine/job/send_out_prepare_payload'

module CASA
  module Engine
    class App

      app_settings = settings

      namespace '/out' do

        get '/payloads' do

          options = {
            'from_handler' => settings.adj_out_payloads_handler,
            'postprocess_handler' => CASA::Engine::Job::SendOutPreparePayload.new(app_settings)
          }

          CASA::Publisher::Strategy::Sinatra.new(self, options).execute

        end

      end

    end
  end
end
