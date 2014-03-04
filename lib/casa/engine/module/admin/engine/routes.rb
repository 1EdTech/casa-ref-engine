require 'casa/engine/app'
require 'casa/engine/app/module_erb'

module CASA
  module Engine
    class App

      namespace '/admin/engine' do

        get '' do
          module_erb 'index@admin/engine'
        end

      end

    end
  end
end