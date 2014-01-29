require 'casa/engine/app'
require 'casa/engine/app/configure_job'
require 'casa/engine/job/receive_in'
require 'casa/engine/persistence/adj_in_peers/sequel_storage_handler'
require 'casa/engine/persistence/adj_in_payloads/sequel_storage_handler'

module CASA
  module Engine
    class App

      configure_job :receive_in, CASA::Engine::Job::ReceiveIn,
        'interval' => settings.receiver_module['interval'],
        'adj_in_payloads_handler' => CASA::Engine::Persistence::AdjInPayloads::SequelStorageHandler.new,
        'adj_in_peers_handler' => CASA::Engine::Persistence::AdjInPeers::SequelStorageHandler.new

    end
  end
end