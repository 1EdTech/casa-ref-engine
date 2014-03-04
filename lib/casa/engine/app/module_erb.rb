require 'casa/engine/app'
require 'pathname'

module CASA
  module Engine
    class App

      def module_erb template, options = {}, locals = {}, &block

        segs = template.split '@'
        template = segs.shift.to_sym
        options[:views] = Pathname.new(__FILE__).parent.parent + 'module' + segs.join + 'views' if segs.size > 0

        erb template, options, locals, &block

      end

    end
  end
end