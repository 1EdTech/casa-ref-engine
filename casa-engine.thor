require 'pathname'
require 'json'

class Engine < Thor

  desc 'setup', 'Installation process defining settings/engine.json'

  def setup

    settings_file = get_settings_file

    @settings = {
        'modules' => [],
        'database' => {}
    }

    setup_modules
    setup_database
    save_settings! settings_file

    say 'SETUP COMPLETE', :green

  end

  private

  def get_settings_file

    settings_file = Pathname.new(__FILE__).parent + 'settings/engine.json'

    if File.exists? settings_file
      say 'Found settings/engine.json -- engine is already set up', :green
      if yes? "Would you like to overwrite ('y' to overwrite)?"
        File.delete settings_file
        say 'Settings file deleted', :green
      else
        say 'SETUP ABORTED -- settings/engine.json already exists', :red
        abort
      end
    end

    settings_file

  end

  def setup_modules

    say 'SETUP MODULES', :magenta

    ['publisher','receiver','relay'].each do |mod|
      if yes? "Include #{mod} module ('y' to include)?"
        @settings['modules'].push mod
        say "Including #{mod} module", :cyan
      else
        say "Not including #{mod} module", :cyan
      end
    end

  end

  def setup_database

    setup_database_type

    if @settings['database'][:adapter] != 'sqlite'

      hostname = ask('Hostname:').strip
      @settings['database'][:host] = hostname.length > 0 ? hostname : 'localhost'

      @settings['database'][:user] = ask('Username:').strip

      password = ask('Password:').strip
      @settings['database'][:password] = password if password.length > 0

      @settings['database'][:database] = ask('Database:').strip

    else

      @settings['database'][:database] = ask('Database:').strip

    end

  end

  def setup_database_type

    say 'SETUP DATABASE', :magenta

    if yes? "Use mysql ('y' to use)?"
      @settings['database'][:adapter] = 'mysql2'
      say 'Using mysql2 adapter', :cyan
    elsif yes? "Use mssql ('y' to use)?"
      @settings['database'][:adapter] = 'tinytds'
      say 'Using tinytds adapter', :cyan
    else
      @settings['database'][:adapter] = 'sqlite'
      say 'No database adapter specified', :yellow
      say 'Using sqlite adapter', :cyan
    end

  end

  def save_settings! settings_file

    File.open(settings_file, 'w+') {|f| f.write @settings.to_json }
    say 'Settings file saved', :green

  end

end