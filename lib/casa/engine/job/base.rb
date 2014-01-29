require 'rufus-scheduler'

module CASA
  module Engine
    module Job
      class Base

        def initialize options

          @options = options
          @options.keys.each { |k| self.class.send(:define_method, k.to_sym){ @options[k] } }
          @scheduler = nil

        end

        def started?

          !@scheduler.nil?

        end

        def start! interval, options = {}, &block

          return if started?

          default_options = {:overlap => false, :tag => self.class.name}
          schedule_options = default_options.merge(options)

          scheduler.every interval, schedule_options, &block
          scheduler.jobs(:tag => schedule_options[:tag]).each { |job| job.trigger Time.now }

        end

        def scheduler

          @scheduler ||= Rufus::Scheduler.new

        end

      end
    end
  end
end
