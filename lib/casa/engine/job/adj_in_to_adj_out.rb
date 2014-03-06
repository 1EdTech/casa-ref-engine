require 'casa/engine/job/base'
require 'casa/receiver/strategy/load_from_adj_in_store'
require 'casa/operation/transform/adj_out'

module CASA
  module Engine
    module Job
      class AdjInToAdjOut < Base

        def execute

          CASA::Receiver::Strategy::LoadFromAdjInStore.new({
            'persistence' => {
              'from' => { 'handler' => adj_in_payloads_handler },
              'to' => { 'handler' => adj_out_payloads_handler }
            },
            'transform' => { 'handler' => CASA::Operation::Transform::AdjOut.factory(settings.attributes) },
            'logger' => logger
          }).execute!

        end

      end
    end
  end
end