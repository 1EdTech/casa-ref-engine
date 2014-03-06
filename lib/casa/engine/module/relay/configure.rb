require 'casa/engine/app'
require 'casa/engine/job/adj_in_to_adj_out'

module CASA
  module Engine
    class App

      configure do

        settings.set :adj_in_to_adj_out_job, CASA::Engine::Job::AdjInToAdjOut.new(self)

        scheduler.every '24h', {:overlap => false, :tag => :adj_in_to_adj_out} do
          adj_in_to_adj_out_job.execute
        end

      end

    end
  end
end