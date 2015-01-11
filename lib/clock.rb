require 'clockwork'
require_relative 'ls_api'

module Clockwork

  handler do |job|
    Log.blue("Clockwork: running #{job}")
  end

  every(1.day, 'Sending Reminders', :at => '12:00') {
    days_out = 10

    l = LsAPI.new
    alerts = l.work_alerts_for_upcoming_days(days_out.to_i)
    body = alerts.map{ |a| "#{a}\n\n" }

    Log.green("Sending alerts...")

    message = Pony.mail(:to => "clint@ctro.net", :from => "clint@ctro.net",
    :subject => "I think these people are coming in the next #{days_out} days",
    :body => body)

    Log.green(message.to_s)
    "OK"
  }

end
