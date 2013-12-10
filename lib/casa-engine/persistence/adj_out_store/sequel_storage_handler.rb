require 'sequel'
require 'multi_json'
require 'casa-payload'

module CASA
  module Engine
    module Persistence
      module AdjOutStore
        class SequelStorageHandler

          def initialize options = nil

            fail 'AdjOutStore::SequelStorageHandler requires connection option' unless defined? DB

            DB.run 'CREATE TABLE IF NOT EXISTS `adj_out_payloads` (
              `id` varchar(255) NOT NULL,
              `originator_id` varchar(36) NOT NULL,
              `data` text NOT NULL,
              PRIMARY KEY (`id`,`originator_id`)
            )'

          end

          def create payload_hash, options = nil

            payload = CASA::Payload::TransitPayload.new payload_hash
            raise PayloadValidationError unless payload.validates?

            DB[:adj_out_payloads].insert({
              :id => payload['identity']['id'],
              :originator_id => payload['identity']['originator_id'],
              :data => payload.to_hash
            })

          end

          def get payload_identity, options = nil

            row = DB[:adj_out_payloads].where(:id => payload_identity['id'], :originator_id => payload_identity['originator_id']).first

            if row
              CASA::Payload::TransitPayload.new JSON.parse row[:data]
            else
              false
            end

          end

          def get_all options = nil

            payloads = []
            DB[:adj_out_payloads].each do |row|
              payloads.push CASA::Payload::TransitPayload.new JSON.parse row[:data]
            end
            payloads

          end

        end
      end
    end
  end
end