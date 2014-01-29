require 'logger'
require 'casa/engine/app'
require 'casa/support/scoped_logger'

module CASA
  module Engine
    class App
      class << self

        def configure_route klass, route

          route = [route] unless route.is_a? Array

          route.each do |route|
            CASA::Engine::App.send(route['method'], route['path']){ klass.call(env) }
          end

        end

      end
    end
  end
end