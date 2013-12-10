require 'pathname'
require 'yaml'
require 'casa-engine'

base_path = Pathname.new(__FILE__).parent
settings_file = base_path + "settings.yml"

fail "Settings file not defined -- run `thor engine:setup`" unless File.exists? settings_file

settings = YAML::load File.read settings_file

# Loads each module into CASA::Engine::Router
settings['modules'].each do |mod|
  require "casa-engine/module/#{mod}"
end

run CASA::Engine::App