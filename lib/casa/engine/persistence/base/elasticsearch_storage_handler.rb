require 'casa/engine/persistence/base/base_storage_handler'

module CASA
  module Engine
    module Persistence
      module Base
        class ElasticsearchStorageHandler < BaseStorageHandler

          def initialize options = {}
            super merged_options(options, {
              :__type__ => 'elasticsearch',
              :index => 'casa'
            })
            require_property! :db
            require_property! :index
          end

        end
      end
    end
  end
end