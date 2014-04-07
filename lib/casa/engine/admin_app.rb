require 'sinatra/base'
require 'sinatra/namespace'

module CASA
  module Engine
    class AdminApp < Sinatra::Base

      register Sinatra::Namespace

      use Rack::Auth::Basic, "CASA Admin" do |username, password|
        username == settings.admin['username'] && password == settings.admin['password']
      end

    end
  end
end