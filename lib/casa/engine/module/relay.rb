require 'casa/engine/app'
require 'casa/engine/app/class/configure_job'
require 'casa/engine/job/load_from_adj_in_store'
require 'casa/engine/persistence/adj_in_payloads/sequel_storage_handler'
require 'casa/engine/persistence/adj_out_payloads/sequel_storage_handler'
require 'casa/operation/transform/adj_out'

module CASA
  module Engine
    class App

      configure_job :adj_in_to_adj_out, CASA::Engine::Job::LoadFromAdjInStore,
        'interval' => settings.jobs['intervals']['adj_in_to_adj_out'],
        'from_handler' => CASA::Engine::Persistence::AdjInPayloads::SequelStorageHandler.new,
        'to_handler' => CASA::Engine::Persistence::AdjOutPayloads::SequelStorageHandler.new,
        'transform_handler' => CASA::Operation::Transform::AdjOut.factory(settings.attributes)

    end
  end
end