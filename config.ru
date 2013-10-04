require './web.rb'

Rack::Handler::Thin.run Sinatra::Application, :Port => 4567

