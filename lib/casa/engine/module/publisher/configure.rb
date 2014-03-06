require 'casa/engine/app'
require 'casa/engine/job/load_payloads/adj_in_to_adj_out'
require 'casa/engine/job/load_payloads/local_to_adj_out'

module CASA
  module Engine
    class App

      configure do

        if settings.modules.include? 'receiver'

          settings.set :adj_in_to_adj_out_job, CASA::Engine::Job::LoadPayloads::AdjInToAdjOut.new(self)

          scheduler.every '24h', {:overlap => false, :tag => :adj_in_to_adj_out} do
            adj_in_to_adj_out_job.execute
          end

        end

        if settings.modules.include? 'local'

          settings.set :local_to_adj_out_job, CASA::Engine::Job::LoadPayloads::LocalToAdjOut.new(self)

          scheduler.every '24h', {:overlap => false, :tag => :local_to_adj_out} do
            local_to_adj_out_job.execute
          end

        end

      end

    end
  end
end