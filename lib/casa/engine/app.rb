require 'sinatra/base'
require 'sinatra/namespace'
require 'rufus-scheduler'

module CASA
  module Engine
    class App < Sinatra::Base

      register Sinatra::Namespace

      configure do

        scheduler = Rufus::Scheduler.new

        def scheduler.trigger_jobs selector
          jobs(selector).each { |job| job.trigger Time.now }
        end

        set :scheduler, scheduler

      end

    end
  end
end