require 'pathname'
require 'yaml'

class Engine < Thor

  desc 'setup', 'Installation process defining settings.yml'

  def setup

    settings_file = Pathname.new(__FILE__).parent + 'settings.yml'

    if File.exists? settings_file
      say 'Found settings.yml -- engine is already set up', :green
      if yes? "Would you like to overwrite ('y' to overwrite)?"
        File.delete settings_file
        say 'Settings file deleted', :green
      else
        return say 'SETUP ABORTED -- settings.yml already exists', :red
      end
    end

    settings = {
        'modules' => [],
        'database' => {}
    }

    say 'SETUP MODULES', :magenta

    ['publisher'].each do |mod|
      if yes? "Include #{mod} module ('y' to include)?"
        settings['modules'].push mod
        say "Including #{mod} module", :cyan
      else
        say "Not including #{mod} module", :cyan
      end
    end

    say 'SETUP DATABASE', :magenta

    if yes? "Use mysql ('y' to use)?"
      settings['database'][:adapter] = 'mysql2'
      say 'Using mysql2 adapter', :cyan
    elsif yes? "Use mssql ('y' to use)?"
      settings['database'][:adapter] = 'tinytds'
      say 'Using tinytds adapter', :cyan
    else
      settings['database'][:adapter] = 'sqlite'
      say 'No database adapter specified', :yellow
      say 'Using sqlite adapter', :cyan
    end

    if settings['database'][:adapter] != 'sqlite'

      hostname = ask('Hostname:').strip
      settings['database'][:host] = hostname.length > 0 ? hostname : 'localhost'

      settings['database'][:user] = ask('Username:').strip

      password = ask('Password:').strip
      settings['database'][:password] = password if password.length > 0

      settings['database'][:database] = ask('Database:').strip

    else

      settings['database'][:database] = ask('Database:').strip

    end



    File.open(settings_file, 'w+') {|f| f.write settings.to_yaml }
    say 'Settings file saved', :green

    say 'SETUP COMPLETE', :green

  end

end