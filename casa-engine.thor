require 'pathname'
require 'yaml'

class Engine < Thor

  desc 'setup', 'Installation process defining settings.yml'

  def setup

    settings_file = Pathname.new(__FILE__).parent + 'settings.yml'

    if File.exists? settings_file
      say 'Found settings.yml -- engine is already set up', :green
      if ask("Would you like to overwrite ('Y' to overwrite)?") == 'Y'
        File.delete settings_file
        say 'Settings file deleted', :cyan
      else
        return say 'SETUP ABORTED', :green
      end
    end

    settings = {
        'modules' => []
    }

    ['publisher'].each do |mod|
      if ask("Include #{mod} module ('Y' to include)?") == 'Y'
        settings['modules'].push mod
      end
    end

    File.open(settings_file, 'w+') {|f| f.write settings.to_yaml }

    say 'SAVED settings.yml -- SETUP COMPLETE', :green

  end

end