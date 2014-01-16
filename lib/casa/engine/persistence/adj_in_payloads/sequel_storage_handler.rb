require 'casa/payload/local_payload'

module CASA
  module Engine
    module Persistence
      module AdjInPayloads
        class SequelStorageHandler < ::CASA::Engine::Persistence::AbstractPayloads::SequelStorageHandler

          def initialize options = nil

            super :adj_in_payloads, merged_options(options, {
              :schema_class => ::CASA::Payload::LocalPayload
            })

          end

        end
      end
    end
  end
end