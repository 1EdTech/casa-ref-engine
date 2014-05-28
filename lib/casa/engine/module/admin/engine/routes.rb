require 'json'
require 'casa/engine/admin_app'

module CASA
  module Engine
    class AdminApp

      def allow_cors
        {
            "Access-Control-Allow-Origin" => settings.admin['origin'],
            "Access-Control-Allow-Methods" => "GET, POST, PUT, DELETE, OPTIONS",
            "Access-Control-Allow-Headers" => "Origin, X-Requested-With, Content-Type, Accept",
            "Access-Control-Allow-Credentials" => "true"
        }
      end

      def handlers

        arr = []
        arr.push settings.local_payloads_index_handler if settings.respond_to?(:local_payloads_index_handler)
        arr.push settings.local_payloads_handler
        arr

      end

      def each_handler *args

        if args.length > 0
          meth = args.shift
          handlers.each { |handler| handler.send meth.to_sym, *args }
        end

      end

      def any_handler *args

        if args.length > 0
          meth = args.shift
          handlers.each do |handler|
            retval = handler.send meth, *args
            return retval if retval
          end
        end

        nil

      end

      options '*' do

        headers allow_cors

      end

      get '/settings' do

        headers allow_cors

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

      namespace '/attributes' do

        get '' do

          headers allow_cors

          json(settings.attributes.map(){ |name,attr| {
              'name' => name,
              'uuid' => attr.uuid,
              'section' => attr.section,
              'handler' => attr.class.name,
              'options' => attr.options
          } })

        end

        if settings.attributes_handler

          put '/:name' do

            headers allow_cors

            attribute_name = params[:name]

            begin

              request.body.rewind
              new_options = JSON.parse request.body.read.strip

              error 422, 'Unprocessable Entity' unless new_options.is_a? ::Hash

              error 404, 'Not Found' unless settings.attributes.has_key? attribute_name

              if Digest::MD5.hexdigest(settings.attributes[attribute_name].options.sort.to_json) == Digest::MD5.hexdigest(new_options.sort.to_json)
                error 304, 'Not Modified'
              end

              settings.attributes_handler.delete attribute_name
              settings.attributes_handler.create attribute_name, new_options

              settings.apps.each do |app|
                app.attributes[attribute_name].options = new_options
              end

              status 201
              'Created'

            rescue ::JSON::ParserError

              error 400, 'Bad Request' # JSON wasn't valid

            end

          end

          delete '/:name' do

            headers allow_cors

            attribute_name = params[:name]

            if settings.attributes_handler.get attribute_name

              settings.attributes_handler.delete attribute_name

              settings.apps.each do |app|
                if app.attributes_default_options and app.attributes_default_options.has_key? attribute_name
                  app.attributes[attribute_name].options = app.attributes_default_options[attribute_name]
                else
                  app.attributes[attribute_name].options = {}
                end
              end

              status 204

            else

              error 404, 'Not Found'

            end

          end

        end

      end

      namespace '/local' do

        put '/payloads/:originator_id/:id' do

          headers allow_cors

          identity = {
            'originator_id' => params[:originator_id],
            'id' => params[:id]
          }

          error 409, 'Conflict' unless identity['originator_id'] == settings.id

          begin

            request.body.rewind
            attributes = JSON.parse request.body.read.strip

            previous_payload = any_handler(:get, identity)

            if previous_payload
              previous_payload['attributes'].delete 'timestamp'
              attributes.delete 'timestamp'
              if Digest::MD5.hexdigest(previous_payload['attributes'].sort.to_json) == Digest::MD5.hexdigest(attributes.sort.to_json)
                error 304, 'Not Modified'
              end
            end

            attributes['timestamp'] = Time.now.utc.iso8601

            new_payload = {
              'identity' => identity,
              'original' => attributes,
              'attributes' => attributes,
              'journal' => []
            }

            each_handler :delete, identity if previous_payload

            unless settings.local_payloads_handler.create new_payload
              settings.local_payloads_handler.create previous_payload if previous_payload
              error 422, 'Unprocessable Entity'
            end

            CASA::Engine::App.local_to_adj_out_job.execute if CASA::Engine::App.local_to_adj_out_job

          rescue ::JSON::ParserError

            error 400, 'Bad Request' # JSON wasn't valid

          end

          status 201
          'Created'

        end

        delete '/payloads/:originator_id/:id' do

          headers allow_cors

          identity = {
            'originator_id' => params[:originator_id],
            'id' => params[:id]
          }

          unless any_handler(:get, identity).nil?
            each_handler :delete, identity
            status 204
          else
            error 404, 'Not Found'
          end

        end

      end

      namespace '/in' do

        get '/peers' do

          headers allow_cors

          peers = []
          settings.adj_in_peers_handler.get_all.each do |row|
            peers.push({
              'name' => row[:name],
              'uri' => row[:uri],
              'secret' => row[:secret],
            })
          end

          json peers

        end

        put '/peers/:name' do

          headers allow_cors

          peer_name = params[:name]

          begin

            request.body.rewind
            new_peer = JSON.parse request.body.read.strip

            error 422, 'Unprocessable Entity' unless new_peer.is_a? ::Hash

            puts peer_name

            current_peer = settings.adj_in_peers_handler.get peer_name

            if current_peer and Digest::MD5.hexdigest(current_peer.sort.to_json) == Digest::MD5.hexdigest(new_peer.sort.to_json)
              error 304, 'Not Modified'
            end

            settings.adj_in_peers_handler.delete peer_name if current_peer
            settings.adj_in_peers_handler.create new_peer

            status 201
            'Created'

          rescue ::JSON::ParserError

            error 400, 'Bad Request' # JSON wasn't valid

          end

        end

        delete '/peers/:name' do

          headers allow_cors

          peer_name = params[:name]

          begin

            current_peer = settings.adj_in_peers_handler.get peer_name

            error 404, 'Not Found' unless current_peer

            settings.adj_in_peers_handler.delete peer_name

            status 204
            'No Content'

          rescue ::JSON::ParserError

            error 400, 'Bad Request' # JSON wasn't valid

          end

        end

      end

    end
  end
end