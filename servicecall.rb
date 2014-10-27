require 'sinatra'
require "sinatra/reloader" if development?

configure :development do
  set :dump_errors, true
end

@@keys = ENV["API_KEYS"].split(",")

get '/subs' do
  logger.info(@@keys)
  "#{@@keys.length}"
end

get '/ping' do "PONG" end
