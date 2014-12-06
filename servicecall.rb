require 'sinatra'
require 'sinatra/reloader' if development?
require 'pony'
require './lib/ls_api'
require './lib/logger'


require "./config/#{settings.environment}.rb"

# Index
get '/' do "Litespeed ServiceCall" end

# Monitor:
get '/ping' do "PONG" end


get '/reminder' do
  email = params[:email]
  days_out = params[:days_out]

  l = LsAPI.new
  alerts = l.work_alerts_for_upcoming_days(days_out.to_i)

  Log.green("Sending alerts...")

  message = Pony.mail(:to => email, :from => email,
  :subject => "I think these people are coming in the next #{days_out} days",
  :body => alerts)

  Log.green(message.to_s)
  "OK"
end
