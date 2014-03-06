require 'casa/engine/app'
require 'casa/engine/job/receive_in'

module CASA
  module Engine
    class App

      configure do

        scheduler.trigger_jobs :tag => :receive_in

      end

    end
  end
end