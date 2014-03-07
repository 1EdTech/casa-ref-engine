require 'casa/engine/persistence/abstract_payloads/elasticsearch_storage_handler'
require 'casa/payload/local_payload'

module CASA
  module Engine
    module Persistence
      module LocalPayloads
        class ElasticsearchStorageHandler < ::CASA::Engine::Persistence::AbstractPayloads::ElasticsearchStorageHandler

          def initialize options = nil

            super merged_options(options, {
              :type => 'local_payload',
              :schema_class => ::CASA::Payload::LocalPayload
            })

          end

        end
      end
    end
  end
end