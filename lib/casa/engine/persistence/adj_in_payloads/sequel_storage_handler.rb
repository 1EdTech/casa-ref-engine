require 'casa/engine/persistence/abstract_payloads/sequel_storage_handler'
require 'casa/payload/local_payload'

module CASA
  module Engine
    module Persistence
      module AdjInPayloads
        class SequelStorageHandler < ::CASA::Engine::Persistence::AbstractPayloads::SequelStorageHandler

          def initialize options = nil

            super merged_options(options, {
              :db_table => :adj_in_payloads,
              :schema_class => ::CASA::Payload::LocalPayload
            })

          end

        end
      end
    end
  end
end