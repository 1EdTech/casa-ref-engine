require 'sinatra/base'
require 'rufus-scheduler'

module CASA
  module Engine
    class App < Sinatra::Base

      def self.reset_routes!
        @routes = {}
      end

    end
  end
end