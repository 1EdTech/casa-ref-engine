require 'pathname'

module CASA
  module Engine
    module Attribute
      class Loader

        attr_reader :path

        def initialize path
          @path = Pathname.new path
        end

        def definitions
          @definitions ||= files.map { |file| JSON.parse File.read file }
        end

        def files
          @files ||= Dir.glob(@path + "**/*.json")
        end

      end
    end
  end
end