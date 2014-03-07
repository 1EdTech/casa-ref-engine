require 'casa/engine/app'
require 'casa/engine/job/receive_in'
require 'casa/engine/support/scheduled_job'

module CASA
  module Engine
    class App

      configure do

        settings.set(:receive_in_job, CASA::Engine::Support::ScheduledJob.new(:every, settings.jobs['intervals']['receive_in']) do

          if CASA::Engine::Job::ReceiveIn.new(settings).execute
            adj_in_to_local_job.execute if adj_in_to_local_job
            adj_in_to_adj_out_job.execute if adj_in_to_adj_out_job
          end

        end)

      end

    end
  end
end