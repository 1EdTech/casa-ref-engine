require 'pathname'
require 'json'
require 'sequel'

require 'casa/engine/app'
require 'casa/attribute/loader'
require 'casa/engine/attribute/loader'
require 'casa/support/scoped_logger'

base_path = Pathname.new(__FILE__).parent



# # # # # # # # # # # # # # # # # # # #
#
#   SETTINGS
#
# # # # # # # # # # # # # # # # # # # #

settings_file = base_path + "settings/engine.json"

unless File.exists? settings_file
  abort "\e[31m\e[1mSettings file `settings/engine.json` is not defined\e[0m\n\e[31mRun 'thor engine:setup' to resolve"
end

settings = JSON::parse File.read settings_file




# # # # # # # # # # # # # # # # # # # #
#
#   ATTRIBUTES
#
# # # # # # # # # # # # # # # # # # # #

CASA::Engine::Attribute::Loader.new(base_path + 'settings' + 'attributes').definitions.each do |attribute|
  CASA::Attribute::Loader.load! attribute
end



# # # # # # # # # # # # # # # # # # # #
#
#   CORE
#
# # # # # # # # # # # # # # # # # # # #

require 'casa/engine/app'

CASA::Engine::App.set settings

CASA::Engine::App.set :attributes, CASA::Attribute::Loader.loaded

logger = ::Logger.new STDOUT
logger.level = ::Logger::DEBUG
logger.datetime_format = '%Y-%m-%d %H:%M:%S'
CASA::Engine::App.set :logger, CASA::Support::ScopedLogger.new_without_scope(logger)



# # # # # # # # # # # # # # # # # # # #
#
#   DATABASE
#
# # # # # # # # # # # # # # # # # # # #

# Check to make sure dependencies are installed
deps = {
  'mysql2' => ['mysql2'],
  'tinytds' => ['tiny_tds'],
  'sqlite' => ['sqlite3']
}[settings['database']['adapter']].each do |dep|
  begin
    require dep
  rescue LoadError
    abort "\e[31m\e[1mDatabase adapter '#{settings['database']['adapter']}' requires `#{dep}' gem\e[0m\n\e[31mRun 'bundle install' to resolve (must not '--without #{settings['database']['adapter']}')'"
  end
end


# Setup the database under the DB variable
sequel_connection = Sequel.connect settings['database'].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

{
  'adj_in_payloads' => 'AdjInPayloads',
  'adj_in_peers' => 'AdjInPeers',
  'adj_out_payloads' => 'AdjOutPayloads',
  'local_payloads' => 'LocalPayloads'
}.each do |key, name|

  require "casa/engine/persistence/#{key}/sequel_storage_handler"
  klass = "CASA::Engine::Persistence::#{name}::SequelStorageHandler".split('::').inject(Object) {|o,c| o.const_get c}

  handler = klass.new({
    :context => CASA::Engine::App.settings,
    :db => sequel_connection
  })

  CASA::Engine::App.set "#{key}_handler".to_sym, handler

end



# # # # # # # # # # # # # # # # # # # #
#
#   INDEX
#
# # # # # # # # # # # # # # # # # # # #

require 'elasticsearch'
elasticsearch_client = Elasticsearch::Client.new 'log' => true

begin
  require 'casa/engine/persistence/local_payloads/elasticsearch_storage_handler'
  klass = CASA::Engine::Persistence::LocalPayloads::ElasticsearchStorageHandler
  handler = klass.new({
    :context => CASA::Engine::App.settings,
    :db => elasticsearch_client,
    :schema_class => false
  })
  CASA::Engine::App.set :local_payloads_index_handler, handler
rescue
  logger.warn('Initialize - Index') { 'Could not initialize Elasticsearch - advanced search functions will not be available' }
end



# # # # # # # # # # # # # # # # # # # #
#
#   MODULES
#
# # # # # # # # # # # # # # # # # # # #

['configure','routes','start'].each do |type|
  settings['modules'].each do |mod|
    if File.exists? Pathname.new(__FILE__).parent + "lib/casa/engine/module/#{mod}/#{type}.rb"
      logger.info "Module - #{mod[0,1].upcase}#{mod[1,mod.size-1]}" do
        require "casa/engine/module/#{mod}/#{type}"
        "#{type[0,1].upcase}#{type[1,type.size-1]}"
      end
    end
  end
end

require 'casa/engine/module/admin/engine/routes.rb'


# # # # # # # # # # # # # # # # # # # #
#
#   RUN
#
# # # # # # # # # # # # # # # # # # # #

run CASA::Engine::App