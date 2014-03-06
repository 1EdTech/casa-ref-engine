require 'casa/engine/job/base'

module CASA
  module Engine
    module Job
      module LoadPayloads
        class Base < ::CASA::Engine::Job::Base

          attr_reader :src
          attr_reader :dst

          def execute

            each_from_src do |payload|

              logger.scoped_block "#{payload['identity']['id']}@#{payload['identity']['originator_id']}" do |logger|

                logger.debug do

                  if respond_to? :transform
                    logger.debug do
                      transform.execute! payload
                      "Transforming payload"
                    end
                  end

                  if save_in_dst payload
                    "Payload saved"
                  else
                    "Payload not saved - already up-to-date"
                  end

                end

              end

            end

          end

          def all_from_src

            src.get_all

          end

          def each_from_src

            all_from_src.each do |payload|
              yield payload
            end

          end

          def matching_in_dst payload

            dst.get payload['identity']

          end

          def save_in_dst payload

            current = matching_in_dst payload

            unless current and current['attributes']['timestamp'] >= payload['attributes']['timestamp']
              dst.delete current['identity'] if current
              dst.create payload
              true
            else
              false
            end

          end

        end
      end
    end
  end
end