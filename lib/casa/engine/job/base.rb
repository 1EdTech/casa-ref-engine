require 'delegate'
require 'casa/support/scoped_logger'

module CASA
  module Engine
    module Job
      class Base < ::SimpleDelegator

        attr_accessor :logger

        def initialize context
          super context
          @logger = CASA::Support::ScopedLogger.new(self.class.name.split('::').last, __getobj__.settings.logger)
        end

      end
    end
  end
end