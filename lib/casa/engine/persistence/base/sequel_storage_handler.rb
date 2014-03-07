require 'casa/engine/persistence/base/base_storage_handler'

module CASA
  module Engine
    module Persistence
      module Base
        class SequelStorageHandler < BaseStorageHandler

          def initialize options = nil
            super merged_options(options, {
              :__type__ => 'sequel'
            })
            require_property! :db
            require_property! :db_table
          end

        end
      end
    end
  end
end