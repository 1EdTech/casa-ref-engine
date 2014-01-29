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
    configure_modules
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

    say_section_title 'SETUP MODULES'

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

    say_section_title 'SETUP DATABASE'

    setup_database_type

    if @settings['database'][:adapter] != 'sqlite'
      setup_database_connection
    else
      setup_database_sqlite
    end

  end

  def setup_database_connection

    hostname = ask('Hostname:').strip
    @settings['database'][:host] = hostname.length > 0 ? hostname : 'localhost'

    @settings['database'][:user] = ask('Username:').strip

    password = ask('Password:').strip
    @settings['database'][:password] = password if password.length > 0

    @settings['database'][:database] = ask('Database:').strip

  end

  def setup_database_sqlite

    @settings['database'][:database] = ask('Database:').strip

  end

  def setup_database_type

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

  def configure_modules

    @settings['modules'].each do |mod|
      self.send "configure_#{mod}_module".to_sym
    end

  end

  def configure_publisher_module

  end

  def configure_receiver_module

    @settings['receiver_module'] = {}
    say_section_title 'CONFIGURE RECEIVER MODULE'
    configure_module_interval 'receiver'

  end

  def configure_relay_module

    @settings['relay_module'] = {}
    say_section_title 'CONFIGURE RELAY MODULE'
    configure_module_interval 'relay'

  end

  def configure_module_interval name
    refresh = ask('Refresh interval (such as "30s", "10m", "2h" or "1d"; blank for default) :').strip
    @settings["#{name}_module"]['interval'] = refresh if refresh.length > 0
  end

  def say_section_title text
    say text, :magenta
  end

  def save_settings! settings_file

    File.open(settings_file, 'w+') {|f| f.write @settings.to_json }
    say 'Settings file saved', :green

  end

end