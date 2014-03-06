require 'casa/engine/app'
require 'casa/engine/job/load_payloads/adj_in_to_local'

module CASA
  module Engine
    class App

      configure do

        if settings.modules.include? 'receiver'

          settings.set :adj_in_to_local_job, CASA::Engine::Job::LoadPayloads::AdjInToLocal.new(self)

          scheduler.every '24h', {:overlap => false, :tag => :adj_in_to_local} do
            adj_in_to_local_job.execute
            scheduler.trigger_jobs :tag => :local_to_adj_out
          end

        end

      end

    end
  end
end