require 'casa-engine/app'

module CASA
  module Engine
    class Router

      def self.add app
        app['routes'].each do |route|
          CASA::Engine::App.send(route['method'], route['path']){ app['class'].call(env) }
        end
      end

      def self.reset!
        CASA::Engine::App.reset_routes!
      end

    end
  end
end