require 'casa/engine/job/load_payloads/base_to_adj_out'

module CASA
  module Engine
    module Job
      module LoadPayloads
        class LocalToAdjOut < BaseToAdjOut

          def initialize *args

            super *args
            @src = local_payloads_handler

          end

          def all_from_src

            super.keep_if { |payload| payload['identity']['originator_id'] == id }

          end

        end
      end
    end
  end
end