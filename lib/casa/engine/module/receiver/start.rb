require 'casa/engine/app'
require 'casa/engine/job/receive_in'

module CASA
  module Engine
    class App

      configure do

        receive_in_job.execute

      end

    end
  end
end