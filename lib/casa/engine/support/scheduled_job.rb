require 'rufus-scheduler'

module CASA
  module Engine
    module Support
      class ScheduledJob

        def initialize *args, &block
          @scheduler = Rufus::Scheduler.new
          @args = args
          @block = block
          start
        end

        def start
          @scheduler.send *@args, &@block
        end

        def job
          @scheduler.jobs.first
        end

        def execute
          job.trigger Time.now
        end

      end
    end
  end
end
