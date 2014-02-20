require 'sinatra/base'
require 'sinatra/namespace'
require 'rufus-scheduler'

module CASA
  module Engine
    class App < Sinatra::Base

      register Sinatra::Namespace

    end
  end
end