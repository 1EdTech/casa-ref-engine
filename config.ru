require 'pathname'
require 'yaml'
require 'casa-engine'

base_path = Pathname.new(__FILE__).parent
settings_file = base_path + "settings.yml"

fail "Settings file not defined -- run `thor engine:setup`" unless File.exists? settings_file

settings = YAML::load File.read settings_file

settings['modules'].each do |mod|
  require "casa-engine/#{mod}"
end

run CASA::Engine::Router.execute!