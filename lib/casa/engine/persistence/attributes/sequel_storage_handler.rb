require 'casa/engine/persistence/base/sequel_storage_handler'

module CASA
  module Engine
    module Persistence
      module Attributes
        class SequelStorageHandler < CASA::Engine::Persistence::Base::SequelStorageHandler

          def initialize options = nil

            super merged_options(options, {
              :db_table => :attributes
            })

            db.run "CREATE TABLE IF NOT EXISTS `#{db_table}` (
              `name` varchar(255) NOT NULL,
              `options` text NOT NULL,
              PRIMARY KEY (`name`)
            )"

          end

          def get name, options = nil

            row = db[db_table].where(:name => name).first
            row ? row : false

          end

          def get_all options = nil

            db[db_table]

          end

        end
      end
    end
  end
end