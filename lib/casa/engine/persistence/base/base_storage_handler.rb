require 'ostruct'

module CASA
  module Engine
    module Persistence
      class BaseStorageHandler < OpenStruct

        def initialize options = nil

          if options.has_key?(:table) or options.has_key?('table')
            raise RuntimeError.new "Options when initializing #{self.class.name} may not contain key 'table'"
          end

          super options ? options : {}

        end

        def merged_options options, base_options

          (base_options ? base_options : {}).merge(options ? options : {})

        end

        def require_property! property

          fail "#{self.class.name} requires #{property} option" unless send property

        end

      end
    end
  end
end