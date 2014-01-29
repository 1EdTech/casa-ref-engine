require 'casa/engine/app'
require 'casa/engine/app/configure_job'
require 'casa/engine/job/load_from_adj_in_store'
require 'casa/engine/persistence/adj_in_payloads/sequel_storage_handler'
require 'casa/engine/persistence/local_payloads/sequel_storage_handler'
require 'casa/receiver/strategy/adj_in_transform'

module CASA
  module Engine
    class App

      configure_job :adj_in_to_local, CASA::Engine::Job::LoadFromAdjInStore,
        'interval' => settings.jobs['intervals']['adj_in_to_local'],
        'from_handler' => CASA::Engine::Persistence::AdjInPayloads::SequelStorageHandler.new,
        'to_handler' => CASA::Engine::Persistence::LocalPayloads::SequelStorageHandler.new,
        'transform_handler' => CASA::Receiver::Strategy::AdjInTransform.factory(settings.attributes)

    end
  end
end