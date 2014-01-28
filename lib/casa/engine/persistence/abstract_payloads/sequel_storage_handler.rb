require 'json'

module CASA
  module Engine
    module Persistence
      module AbstractPayloads
        class SequelStorageHandler

          attr_accessor :table
          attr_accessor :options

          def initialize table, options = nil

            @table = table
            @options = options ? options : {}

            setup!

          end

          def setup!

            db.run "CREATE TABLE IF NOT EXISTS `#{table}` (
              `id` varchar(255) NOT NULL,
              `originator_id` varchar(36) NOT NULL,
              `data` text NOT NULL,
              PRIMARY KEY (`id`,`originator_id`)
            )"

          end

          def db

            fail 'DB must be defined' unless defined? DB
            fail 'DB must be defined as a Sequel::Database' unless defined? DB.is_a?(Sequel::Database)
            DB

          end

          def create payload_hash, options = nil

            payload_hash = payload_hash.to_hash

            begin
              @options[:schema_class].new(payload_hash).validate! if @options.has_key? :schema_class
              db[table].insert(
                :id => payload_hash['identity']['id'],
                :originator_id => payload_hash['identity']['originator_id'],
                :data => payload_hash.to_json
              )
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
            db[table].each do |row|
              begin
                payloads.push make_payload_from_row row
              rescue Exception => e
                puts e
                # do nothing
              end
            end
            payloads

          end

          def delete payload_identity, options = nil

            row_query_for_identity(payload_identity, options).delete

          end

          def reset! options = nil

            db.run "TRUNCATE `#{table}`"

          end

          private

          def payload_data payload_identity, options = nil

            JSON.parse row_for_identity(payload_identity, options)[:data]

          end

          def make_payload data, options = nil

            @options.has_key?(:schema_class) ? @options[:schema_class].new(data).validate! : data

          end

          def make_payload_from_row row, options = nil

            make_payload JSON.parse(row[:data]), options

          end

          def row_for_identity payload_identity, options = nil

            row_query_for_identity(payload_identity, options).first

          end

          def row_query_for_identity payload_identity, options = nil

            db[table].where payload_identity.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

          end

          def merged_options base_options, options

            (base_options ? base_options : {}).merge(options ? options : {})

          end

        end
      end
    end
  end
end