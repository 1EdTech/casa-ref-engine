require 'sinatra/base'

module CASA
  module Engine
    class Router < Sinatra::Base

      @@apps = []

      def self.add app
        @@apps.push app
      end

      def self.reset!
        @@apps = []
        reset_routes!
      end

      def self.set_routes!
        @@apps.each do |app|
          app['routes'].each do |route|
            send(route['method'], route['path']){ app['class'].call(env) }
          end
        end
        self
      end

      def self.reset_routes!
        @routes = {}
      end

      def self.execute!
        set_routes!
      end

    end
  end
end