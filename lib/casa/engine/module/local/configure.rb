require 'casa/engine/app'
require 'casa/engine/job/load_payloads/adj_in_to_local'
require 'casa/engine/job/load_payloads/rebuild_local_index'

module CASA
  module Engine
    class App

      configure do

        scheduler.every '24h', {:overlap => false, :tag => :rebuild_local_index} do
          CASA::Engine::Job::LoadPayloads::RebuildLocalIndex.new(settings).execute
        end

        if settings.modules.include? 'receiver'

          scheduler.every '24h', {:overlap => false, :tag => :adj_in_to_local} do

            CASA::Engine::Job::LoadPayloads::AdjInToLocal.new(settings).execute

            # if an index handler exists and it's not already attached to local payloads handler, go ahead and
            if local_payloads_index_handler
              unless local_payloads_handler == local_payloads_index_handler or local_payloads_handler.index_handler
                local_payloads_handler.index_handler = local_payloads_index_handler
                scheduler.trigger_jobs :tag => :rebuild_local_index
              end
            end

            scheduler.trigger_jobs :tag => :local_to_adj_out

          end

        end

      end

    end
  end
end