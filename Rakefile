# Main mail task
require 'pony'
require 'pp'
require_relative './ls_api'

namespace :mail do

  desc "Mail Service Reminders"
  task :service_reminder do

    # TODO: put this somewhere better
    if ENV["RACK_ENV"] == "production"
      Pony.options = {
        :via => :smtp,
        :via_options => {
          :address => 'smtp.sendgrid.net',
          :port => '587',
          :domain => 'heroku.com',
          :user_name => ENV['SENDGRID_USERNAME'],
          :password => ENV['SENDGRID_PASSWORD'],
          :authentication => :plain,
          :enable_starttls_auto => true
        }
      }
    end

    # Right now defaults to HUB
    l = LsAPI.new
    alerts = l.work_alerts_for_upcoming_days(3)

    Pony.mail(:to => "clint@ctro.net", :from => "clint@ctro.net",
    :subject => 'I tink these people are coming in the next 3 days',
    :body => pp(alerts))

  end

end
