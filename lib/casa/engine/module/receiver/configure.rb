require 'casa/engine/app'
require 'casa/engine/job/receive_in'
require 'casa/engine/support/scheduled_job'

module CASA
  module Engine
    class App

      configure do

        settings.set(:has_loaded_tables, false) unless settings.respond_to?(:has_loaded_tables)

        settings.set(:receive_in_job, CASA::Engine::Support::ScheduledJob.new(:every, settings.jobs['intervals']['receive_in']) do

          if CASA::Engine::Job::ReceiveIn.new(settings).execute or !settings.has_loaded_tables
            adj_in_to_local_job.execute if adj_in_to_local_job
            adj_in_to_adj_out_job.execute if adj_in_to_adj_out_job
            settings.set :has_loaded_tables, true
          end

        end)

      end

    end
  end
end