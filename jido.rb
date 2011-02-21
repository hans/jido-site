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

# Probably shouldn't show you the DB info :)
db = open('redis_info.json') do |f|
  JSON.parse f
end

# Connect to the Redis instance.
# This will be used to cache conjugation results.
cache = Redis.new :host => db['host'], :port => db['port'], :password => db['password']

get '/conjugate/:lang/:verb' do
  content_type :json
  
  cache_query = "verbs:#{params[:lang]}:#{params[:verb]}"
  cached = cache.get cache_query
  
  if cached.nil?
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
  else
    return cached
  end
end
