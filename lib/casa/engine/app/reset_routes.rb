require 'logger'
require 'casa/engine/app'
require 'casa/support/scoped_logger'

module CASA
  module Engine
    class App
      class << self

        def reset_routes!
          @routes = {}
        end

      end
    end
  end
end