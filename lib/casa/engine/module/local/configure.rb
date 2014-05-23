require 'casa/engine/app'
require 'casa/engine/job/load_payloads/adj_in_to_local'
require 'casa/engine/job/load_payloads/rebuild_local_index'
require 'casa/engine/support/scheduled_job'

module CASA
  module Engine
    class App

      configure do

        settings.set(:rebuild_local_index_job, CASA::Engine::Support::ScheduledJob.new(:every, settings.jobs['intervals']['local_index_rebuild']) do
          CASA::Engine::Job::LoadPayloads::RebuildLocalIndex.new(settings).execute
        end)

        if settings.modules.include? 'receiver'

          settings.set(:adj_in_to_local_job, CASA::Engine::Support::ScheduledJob.new(:every, settings.jobs['intervals']['adj_in_to_local']) do

            CASA::Engine::Job::LoadPayloads::AdjInToLocal.new(settings).execute

            # if an index handler exists and it's not already attached to local payloads handler, go ahead and
            if defined? local_payloads_index_handler
              unless local_payloads_handler == local_payloads_index_handler or local_payloads_handler.index_handler
                local_payloads_handler.index_handler = local_payloads_index_handler
                rebuild_local_index_job.execute if rebuild_local_index_job
              end
            end

            local_to_adj_out_job.execute if local_to_adj_out_job

          end)

        end

      end

    end
  end
end