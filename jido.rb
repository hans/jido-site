require 'rubygems'
require 'sinatra'

require 'haml'
require 'json'
require 'jido'
require 'redis'

get '/' do
    haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

# Store conjugator objects so they only need to be initialized once
conjugators = {}

# Connect to the Redis instance.
# This will be used to cache conjugation results.
cache = Redis.new :host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'].to_i, :password => ENV['REDIS_PASSWORD']

get '/conjugate/:lang/:verb' do
  content_type :json
  
  cache_query = "verbs:#{params[:lang]}:#{params[:verb]}"
  cached = cache.exists cache_query
  
  if cached
    return cache.get cache_query
  else
    conjugator = nil
    if conjugators[params[:lang]].nil?
      conjugator = Jido.load params[:lang]
      conjugators[params[:lang]] = conjugator
    else
      conjugator = conjugators[params[:lang]]
    end
    
    ret = conjugator.conjugate(params[:verb]).to_json
    cache.set cache_query, ret
    return ret
  end
end
