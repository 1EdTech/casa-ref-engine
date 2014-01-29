require 'casa/engine/job/base'
require 'casa/relay/strategy/load_from_adj_in'

module CASA
  module Engine
    module Job
      class Relay < Base

        def start!

          super interval do
            CASA::Relay::Strategy::LoadFromAdjIn.new(relay_options).execute!
          end

        end

        def relay_options

          @relay_options ||= {
            'persistence' => {
              'adj_out_payloads' => {
                'handler' => adj_out_payloads_handler
              },
              'adj_in_payloads' => {
                'handler' => adj_in_payloads_handler
              }
            },
            'logger' => logger
          }

        end

      end
    end
  end
end