require 'sinatra'
require 'sinatra/reloader' if development?
require 'pony'
require 'httparty'
require './lib/ls_api'
require './lib/logger'
require './lib/time'

require "./config/#{settings.environment}.rb"


get '/' do erb(:index) end
get '/ping' do "PONG" end

get '/reminder' do
  email = params[:email]
  days_out = params[:days_out]

  l = LsAPI.new
  alerts = l.work_alerts_for_upcoming_days(days_out.to_i)
  body = alerts.map{ |a| "#{a}\n\n" }

  Log.green("Sending alerts...")

  message = Pony.mail(:to => email, :from => email,
  :subject => "I think these people are coming in the next #{days_out} days",
  :body => body)

  Log.green(message.to_s)
  "OK"
end
