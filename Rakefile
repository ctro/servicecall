# Main mail task
require 'pony'
namespace :mail do

  desc "Mail Service Reminders"
  task :service_reminder do
    ENV["API_KEYS"].split(",").each do |key|

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

      Pony.mail(:to => key, :from => key,
      :subject => 'Bring yer bike in',
      :body => 'Sometime.')

      puts "Sent mail to #{key}"
    end
  end

end
