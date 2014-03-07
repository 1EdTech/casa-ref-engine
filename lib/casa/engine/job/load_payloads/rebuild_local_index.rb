require 'casa/engine/job/load_payloads/base'

module CASA
  module Engine
    module Job
      module LoadPayloads
        class RebuildLocalIndex < Base

          def initialize *args

            super *args
            @src = local_payloads_handler
            @dst = local_payloads_handler.index_handler

          end

          def execute

            # do nothing if no destination (meaning no index handler)
            return unless dst

            begin

              # detach index handler so we can work with it
              src.index_handler = nil

              logger.debug do
                dst.reset!
                "Reset index"
              end

              each_from_src do |payload|

                logger.scoped_block "#{payload['identity']['id']}@#{payload['identity']['originator_id']}" do |logger|

                  logger.debug do

                    if save_in_dst payload
                      "Payload saved"
                    else
                      "Payload not saved"
                    end

                  end

                end

              end

            ensure

              # reattach index handler
              src.index_handler = dst

            end

          end

        end
      end
    end
  end
end