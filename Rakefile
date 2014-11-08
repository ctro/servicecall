# Main mail task
require 'pony'
require_relative './lib/ls_api'
require_relative './lib/logger'

namespace :mail do

  desc "Mail Service Reminders"
  task :service_reminder, [:days_out] do |t, args|


    if ENV['RACK_ENV'] == "production"
      require "./config/production.rb"
    end

    # Right now defaults to HUB
    l = LsAPI.new
    alerts = l.work_alerts_for_upcoming_days(args[:days_out].to_i)

    Log.green("Sending alerts...")
    message = Pony.mail(:to => "clint@ctro.net", :from => "clint@ctro.net",
    :subject => 'I think these people are coming in the next 3 days',
    :body => alerts)
    Log.green(message.to_s)
  end

end
