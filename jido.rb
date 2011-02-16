require 'rubygems'
require 'sinatra'

require 'haml'
require 'json'
require 'jido'

get '/' do
    haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

conjugators = {}
get '/conjugate/:lang/:verb' do
    content_type :json
    
    conjugator = nil
    if conjugators[params[:lang]].nil?
	conjugator = Jido.load params[:lang]
	conjugators[params[:lang]] = conjugator
    else conjugator = conjugators[params[:lang]] end

    conjugator.conjugate(params[:verb]).to_json
end
