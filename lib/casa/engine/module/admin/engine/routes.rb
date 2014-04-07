require 'casa/engine/admin_app'

module CASA
  module Engine
    class AdminApp

      get '/settings' do
        json({
          'modules' => settings.modules,
          'database' => settings.database.select(){|k,_| k != 'password'},
          'jobs' => settings.jobs,
          'attributes' => settings.attributes.map(){ |name,attr| {
              'name' => name,
              'uuid' => attr.uuid,
              'section' => attr.section,
              'handler' => attr.class.name
          } }
        })
      end

      get '/attributes' do
        json(settings.attributes.map(){ |name,attr| {
            'name' => name,
            'uuid' => attr.uuid,
            'section' => attr.section,
            'handler' => attr.class.name,
            'options' => attr.options
        } })
      end

    end
  end
end