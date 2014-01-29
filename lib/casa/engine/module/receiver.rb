require 'logger'
require 'pathname'
require 'casa/engine/app'
require 'casa/engine/job/receive_in'
require 'casa/engine/attribute/loader'
require 'casa/engine/persistence/adj_in_peers/sequel_storage_handler'
require 'casa/engine/persistence/adj_in_payloads/sequel_storage_handler'
require 'casa/support/scoped_logger'

module CASA
  module Engine
    class App

      configure do

        base_dir = Pathname.new(__FILE__).parent.parent.parent.parent.parent

        logger = ::Logger.new STDOUT
        logger.level = ::Logger::DEBUG
        logger.datetime_format = '%Y-%m-%d %H:%M:%S'

        receive_in = CASA::Engine::Job::ReceiveIn.new({
          'interval' => settings.receiver_module['interval'],
          'adj_in_payloads_handler' => CASA::Engine::Persistence::AdjInPayloads::SequelStorageHandler.new,
          'adj_in_peers_handler' => CASA::Engine::Persistence::AdjInPeers::SequelStorageHandler.new,
          'logger' => CASA::Support::ScopedLogger.new('ReceiveIn', logger)
        })

        set :receive_in, receive_in

        receive_in.start!

      end

    end
  end
end