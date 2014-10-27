require 'sinatra'
require "sinatra/reloader" if development?

# Load keys from ENV
def api_keys
  @api_keys ||= ENV["API_KEYS"].split(",") rescue []
end

# Index
get '/' do "Litespeed ServiceCall" end

# Monitor:
get '/ping' do "PONG" end

get '/info' do
  <<-info
  Key Length: #{api_keys.length}
  info
end
