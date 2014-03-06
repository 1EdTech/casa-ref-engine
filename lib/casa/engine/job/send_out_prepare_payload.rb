require 'casa/engine/job/base'
require 'casa/operation/filter/adj_out'
require 'casa/operation/translate/adj_out'

module CASA
  module Engine
    module Job
      class SendOutPreparePayload < Base

        attr_reader :adj_out_filter_strategy
        attr_reader :adj_out_translate_strategy

        def initialize *args

          super *args
          @adj_out_filter_strategy = CASA::Operation::Filter::AdjOut.new attributes
          @adj_out_translate_strategy = CASA::Operation::Translate::AdjOut.factory attributes

        end

        def execute payload

          begin

            if adj_out_filter_strategy.allows? payload

              processed_payload = adj_out_translate_strategy.execute(payload)
              processed_payload.delete 'attributes'
              processed_payload

            else

              false

            end

          rescue

            false

          end

        end

      end
    end
  end
end