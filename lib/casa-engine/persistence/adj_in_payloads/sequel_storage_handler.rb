require 'sequel'
require 'multi_json'
require 'casa-payload'

module CASA
  module Engine
    module Persistence
      module AdjInPayloads
        class SequelStorageHandler

          def initialize options = nil

            fail 'AdjOutStore::SequelStorageHandler requires connection option' unless defined? DB

            DB.run 'CREATE TABLE IF NOT EXISTS `adj_in_payloads` (
              `id` varchar(255) NOT NULL,
              `originator_id` varchar(36) NOT NULL,
              `data` text NOT NULL,
              PRIMARY KEY (`id`,`originator_id`)
            )'

          end

          def create payload_hash, options = nil

            payload = CASA::Payload::LocalPayload.new(payload_hash).to_hash

            DB[:adj_in_payloads].insert(
              :id => payload['identity']['id'],
              :originator_id => payload['identity']['originator_id'],
              :data => payload.to_json
            )

          end

          def get payload_identity, options = nil

            row = DB[:adj_in_payloads].where(:id => payload_identity['id'], :originator_id => payload_identity['originator_id']).first
            row ? CASA::Payload::LocalPayload.new(JSON.parse row[:data]) : false

          end

          def delete payload_identity, options = nil

            DB[:adj_in_payloads].where(:id => payload_identity['id'], :originator_id => payload_identity['originator_id']).delete

          end

          def reset! options = nil

            DB.run 'TRUNCATE `adj_in_payloads`'

          end

        end
      end
    end
  end
end