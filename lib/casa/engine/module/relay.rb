require 'logger'
require 'pathname'
require 'casa/engine/app'
require 'casa/engine/job/relay'
require 'casa/engine/persistence/adj_in_payloads/sequel_storage_handler'
require 'casa/engine/persistence/adj_out_payloads/sequel_storage_handler'

module CASA
  module Engine
    class App

      configure do

        logger = ::Logger.new STDOUT
        logger.level = ::Logger::DEBUG
        logger.datetime_format = '%Y-%m-%d %H:%M:%S'

        relay = CASA::Engine::Job::Relay.new({
          'interval' => '2s',
          'adj_in_payloads_handler' => CASA::Engine::Persistence::AdjInPayloads::SequelStorageHandler.new,
          'adj_out_payloads_handler' => CASA::Engine::Persistence::AdjOutPayloads::SequelStorageHandler.new,
          'logger' => logger
        })

        set :relay, relay

        relay.start!

      end

    end
  end
end