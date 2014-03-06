require 'casa/engine/app'
require 'casa/engine/job/adj_in_to_local'

module CASA
  module Engine
    class App

      configure do

        settings.set :adj_in_to_local_job, CASA::Engine::Job::AdjInToLocal.new(self)

        scheduler.every '24h', {:overlap => false, :tag => :adj_in_to_local} do
          adj_in_to_local_job.execute
        end

      end

    end
  end
end