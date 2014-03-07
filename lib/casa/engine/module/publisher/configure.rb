require 'casa/engine/app'
require 'casa/engine/job/load_payloads/adj_in_to_adj_out'
require 'casa/engine/job/load_payloads/local_to_adj_out'
require 'casa/engine/support/scheduled_job'

module CASA
  module Engine
    class App

      configure do

        if settings.modules.include? 'receiver'

          settings.set(:adj_in_to_adj_out_job, CASA::Engine::Support::ScheduledJob.new(:every, settings.jobs['intervals']['adj_in_to_adj_out']) do
            CASA::Engine::Job::LoadPayloads::AdjInToAdjOut.new(settings).execute
          end)

        end

        if settings.modules.include? 'local'

          settings.set(:local_to_adj_out_job, CASA::Engine::Support::ScheduledJob.new(:every, settings.jobs['intervals']['local_to_adj_out']) do
            CASA::Engine::Job::LoadPayloads::LocalToAdjOut.new(settings).execute
          end)

        end

      end

    end
  end
end