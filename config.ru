require 'pathname'
require 'json'
require 'sequel'
require 'casa/engine'

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
DB = Sequel.connect settings['database'].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}



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
#   MODULES
#
# # # # # # # # # # # # # # # # # # # #

settings['modules'].each do |mod|
  require "casa/engine/module/#{mod}"
end



# # # # # # # # # # # # # # # # # # # #
#
#   RUN
#
# # # # # # # # # # # # # # # # # # # #

run CASA::Engine::App