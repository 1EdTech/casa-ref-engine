require 'logger'
require 'casa/engine/app'
require 'casa/support/scoped_logger'

module CASA
  module Engine
    class App
      class << self

        def configure_job name, klass, options = {}

          configure do

            logger = ::Logger.new STDOUT
            logger.level = ::Logger::DEBUG
            logger.datetime_format = '%Y-%m-%d %H:%M:%S'

            default_options = {
              'logger' => CASA::Support::ScopedLogger.new(name.to_s.split('_').select {|w| w.capitalize! || w }.join(''), logger)
            }

            obj = klass.new default_options.merge options
            set name, obj
            obj.start!

          end

        end

      end
    end
  end
end