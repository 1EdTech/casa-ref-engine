require 'casa/engine/job/base'
require 'casa/receiver/strategy/client'

module CASA
  module Engine
    module Job
      class ReceiveIn < Base

        def execute

          true_if_any_received = false

          adj_in_peers_handler.get_all.each do |peer|

            begin

              logger.info peer[:name] do

                strategy_options = {
                  'persistence' => { 'handler' => adj_in_payloads_handler },
                  'logger' => logger
                }

                strategy_options['secret'] = peer[:secret] if peer[:secret]

                CASA::Receiver::Strategy::Client.new(peer[:uri], strategy_options).execute!

                true_if_any_received = true

                "Received payloads"

              end

            rescue CASA::Attribute::LoaderAttributeError,
                   CASA::Attribute::LoaderFileError,
                   CASA::Attribute::LoaderClassError,
                   CASA::Receiver::ReceiveIn::RequestError => e

              logger.fatal('Engine') { e.message }

            rescue CASA::Receiver::ReceiveIn::ResponseError,
                   CASA::Receiver::ReceiveIn::BodyStructureError,
                   CASA::Receiver::ReceiveIn::BodyParserError,
                   StandardError => e

              logger.error(peer[:uri]) { e.message }

            end

          end

          true_if_any_received

        end

      end
    end
  end
end