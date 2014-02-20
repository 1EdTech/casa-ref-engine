require 'casa/engine/app'

module CASA
  module Engine
    class App

      def handle_with klass, options
        klass.new(self, options).execute
      end

      def handle_publish_with options = {}
        handle_with CASA::Publisher::Strategy::Sinatra, options
      end

    end
  end
end