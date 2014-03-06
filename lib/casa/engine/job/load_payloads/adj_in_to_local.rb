require 'casa/engine/job/load_payloads/base'
require 'casa/operation/transform/adj_in'

module CASA
  module Engine
    module Job
      module LoadPayloads
        class AdjInToLocal < Base

          def initialize *args

            super *args
            @src = adj_in_payloads_handler
            @dst = local_payloads_handler

          end

          def transform

            @transform ||= CASA::Operation::Transform::AdjIn.factory(settings.attributes)

          end

          def all_from_src

            super.keep_if { |payload| payload['identity']['originator_id'] != id  }

          end

        end
      end
    end
  end
end