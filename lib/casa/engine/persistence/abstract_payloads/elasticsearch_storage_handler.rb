require 'json'
require 'casa/engine/persistence/base/elasticsearch_storage_handler'

module CASA
  module Engine
    module Persistence
      module AbstractPayloads
        class ElasticsearchStorageHandler < CASA::Engine::Persistence::Base::ElasticsearchStorageHandler

          def initialize options = nil

            super options
            setup!

          end

          def setup!

            unless db.indices.exists index: index
              db.indices.create index: index, body: {}
            end

          end

          def create payload_hash, options = nil

            payload_hash = payload_hash.to_hash

            begin

              schema_class.new(payload_hash).validate! if schema_class

              begin
                delete payload_hash['identity']
              rescue
                # exception here just means that no document already existed by this identity
              end

              db.create index: index,
                        type: type,
                        id: identity_string_from_payload(payload_hash),
                        body: payload_hash

              true

            rescue Exception => e
              false
            end

          end

          def get payload_identity, options = nil

            begin
              response = db.get index: index,
                                type: type,
                                id: identity_string_from_payload_identity(payload_identity)
              make_payload response['_source']
            rescue Exception => e
              false
            end

          end

          def get_query query_string, options = nil

            make_payloads_from db.search index: index,
                                         type: type,
                                         q: query_string

          end

          def get_search search_body, options = nil

            make_payloads_from db.search index: index,
                                         type: type,
                                         body: search_body

          end

          def make_payloads_from response

            payloads = []
            response['hits']['hits'].each do |row|
              begin
                payloads.push make_payload row['_source']
              rescue Exception => e
                # TODO: log this
                # FORNOW: don't expose an error to end clients so ignore
              end
            end
            payloads

          end

          def get_all options = nil

            get_search({
              query: {
                match_all: { }
              }
            })

          end

          def delete payload_identity, options = nil

            db.delete index: index,
                      type: type,
                      id: identity_string_from_payload_identity(payload_identity)

          end

          def reset! options = nil

            teardown!
            setup!

          end

          def teardown! options = nil

            if db.indices.exists(index: index) and db.indices.exists_type(index: index, type: type)
              db.indices.delete_mapping index: index, type: type
            end

          end

          private

          def make_payload data, options = nil

            schema_class ? schema_class.new(data).validate! : data

          end

          def identity_string_from_payload payload_hash

            identity_string_from_payload_identity payload_hash['identity']

          end

          def identity_string_from_payload_identity payload_identity_hash

            "#{payload_identity_hash['id']}@#{payload_identity_hash['originator_id']}"

          end

        end
      end
    end
  end
end