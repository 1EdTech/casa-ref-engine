require 'casa/engine/app'
require 'casa/engine/app/configure_job'
require 'casa/engine/job/relay'
require 'casa/engine/persistence/adj_in_payloads/sequel_storage_handler'
require 'casa/engine/persistence/adj_out_payloads/sequel_storage_handler'

module CASA
  module Engine
    class App

      configure_job :relay, CASA::Engine::Job::Relay,
        'interval' => settings.relay_module['interval'],
        'adj_in_payloads_handler' => CASA::Engine::Persistence::AdjInPayloads::SequelStorageHandler.new,
        'adj_out_payloads_handler' => CASA::Engine::Persistence::AdjOutPayloads::SequelStorageHandler.new

    end
  end
end