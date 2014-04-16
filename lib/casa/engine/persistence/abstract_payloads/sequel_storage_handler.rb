require 'json'
require 'casa/engine/persistence/base/sequel_storage_handler'

module CASA
  module Engine
    module Persistence
      module AbstractPayloads
        class SequelStorageHandler < CASA::Engine::Persistence::Base::SequelStorageHandler

          def initialize options = nil

            super options

            db.run "CREATE TABLE IF NOT EXISTS `#{db_table}` (
              `id` varchar(255) NOT NULL,
              `originator_id` varchar(36) NOT NULL,
              `data` text NOT NULL,
              PRIMARY KEY (`id`,`originator_id`)
            )"

          end

          def create payload_hash, options = nil

            payload_hash = payload_hash.to_hash

            begin

              schema_class.new(payload_hash).validate! if schema_class

              db[db_table].insert(
                :id => payload_hash['identity']['id'],
                :originator_id => payload_hash['identity']['originator_id'],
                :data => payload_hash.to_json
              )

              if use_index_handler?
                index_handler.create payload_hash
              end

              true

            rescue

              false

            end

          end

          def get payload_identity, options = nil

            begin
              make_payload payload_data(payload_identity, options), options
            rescue Exception => e
              false
            end

          end

          def get_all options = nil

            payloads = []
            db[db_table].each do |row|
              begin
                payloads.push make_payload_from_row row
              rescue Exception => e
                # TODO: log this
                # FORNOW: don't expose an error to end clients so ignore
              end
            end
            payloads

          end

          def delete payload_identity, options = nil

            row_query_for_identity(payload_identity, options).delete

            if use_index_handler?
              index_handler.delete payload_identity
            end

          end

          def reset! options = nil

            db.run "TRUNCATE `#{db_table}`"

            if use_index_handler?
              index_handler.reset!
            end

          end

          def teardown! options = nil

            db.run "DROP TABLE `#{@db_table}`"

            if use_index_handler?
              index_handler.teardown!
            end

          end

          private

          def index_handler
            context.local_payloads_index_handler
          end

          def use_index_handler?
            index_handler and index_handler != self
          end

          def payload_data payload_identity, options = nil

            JSON.parse row_for_identity(payload_identity, options)[:data]

          end

          def make_payload data, options = nil

            schema_class ? schema_class.new(data).validate! : data

          end

          def make_payload_from_row row, options = nil

            make_payload JSON.parse(row[:data]), options

          end

          def row_for_identity payload_identity, options = nil

            row_query_for_identity(payload_identity, options).first

          end

          def row_query_for_identity payload_identity, options = nil

            db[db_table].where payload_identity.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

          end

        end
      end
    end
  end
end