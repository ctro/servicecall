require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/ls_api'
require './lib/logger'


require "./config/#{settings.environment}.rb"

# Index
get '/' do "Litespeed ServiceCall" end

# Monitor:
get '/ping' do "PONG" end
