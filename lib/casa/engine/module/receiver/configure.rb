require 'casa/engine/app'
require 'casa/engine/job/receive_in'

module CASA
  module Engine
    class App

      configure do

        settings.set :receiver_job, CASA::Engine::Job::ReceiveIn.new(self)

        scheduler.every '5m', {:overlap => false, :tag => :receive_in} do
          receiver_job.execute
          scheduler.trigger_jobs :tag => :adj_in_to_local
          scheduler.trigger_jobs :tag => :adj_in_to_adj_out
        end

      end

    end
  end
end