require 'rubygems'
require 'sinatra'

require 'haml'

get '/' do
    haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end