require 'casa/engine/app'
require 'casa/engine/job/receive_in'

module CASA
  module Engine
    class App

      configure do

        # if receiver module isn't included, then cache rebuild won't be
        # started as part of that process, so instead trigger it directly
        rebuild_local_index_job.execute unless receive_in_job

      end

    end
  end
end