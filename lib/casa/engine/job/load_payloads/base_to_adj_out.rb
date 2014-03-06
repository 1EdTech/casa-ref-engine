require 'casa/engine/job/load_payloads/base'
require 'casa/operation/transform/adj_out'

module CASA
  module Engine
    module Job
      module LoadPayloads
        class BaseToAdjOut < Base

          def initialize *args

            super *args
            @dst = adj_out_payloads_handler

          end

          def transform

            @transform ||= CASA::Operation::Transform::AdjOut.factory(attributes)

          end

          def all_from_src

            super.keep_if { |payload| payload['attributes']['share'] }

          end

        end
      end
    end
  end
end