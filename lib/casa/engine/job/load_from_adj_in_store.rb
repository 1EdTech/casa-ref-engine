require 'casa/engine/job/base'
require 'casa/receiver/strategy/load_from_adj_in_store'

module CASA
  module Engine
    module Job
      class LoadFromAdjInStore < Base

        def start!

          super interval do
            CASA::Receiver::Strategy::LoadFromAdjInStore.new({
              'persistence' => {
                'from' => { 'handler' => from_handler },
                'to' => { 'handler' => to_handler }
              },
              'transform' => { 'handler' => transform_handler },
              'logger' => logger
            }).execute!
          end

        end

      end
    end
  end
end