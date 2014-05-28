require 'casa/engine/persistence/base/sequel_storage_handler'

module CASA
  module Engine
    module Persistence
      module AdjInPeers
        class SequelStorageHandler < CASA::Engine::Persistence::Base::SequelStorageHandler

          def initialize options = nil

            super merged_options(options, {
              :db_table => :adj_in_peers
            })

            db.run "CREATE TABLE IF NOT EXISTS `#{db_table}` (
              `name` varchar(255) NOT NULL,
              `uri` text NOT NULL,
              `secret` varchar(255) DEFAULT NULL,
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

          def create peer_hash

            begin

              puts peer_hash

              db[db_table].insert(
                  :name => peer_hash['name'],
                  :uri => peer_hash['uri'],
                  :secret => peer_hash.include?('secret') ? peer_hash['secret'] : nil
              )

              true

            rescue

              false

            end

          end

          def delete peer_name

            begin

              db[db_table].where({:name=>peer_name}).delete
              true

            rescue

              false

            end

          end

        end
      end
    end
  end
end