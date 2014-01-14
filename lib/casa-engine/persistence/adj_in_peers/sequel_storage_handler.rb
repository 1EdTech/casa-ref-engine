require 'sequel'

module CASA
  module Engine
    module Persistence
      module AdjInPeers
        class SequelStorageHandler

          def initialize options = nil

            fail 'AdjIPeer::SequelStorageHandler requires connection option' unless defined? DB

            DB.run 'CREATE TABLE IF NOT EXISTS `adj_in_peers` (
              `name` varchar(255) NOT NULL,
              `uri` text NOT NULL,
              `secret` varchar(255) DEFAULT NULL,
              PRIMARY KEY (`name`)
            )'

          end

          def get name, options = nil

            row = DB[:adj_in_peers].where(:name => name).first
            row ? row : false

          end

          def get_all options = nil

            DB[:adj_in_peers]

          end

        end
      end
    end
  end
end