# Main mail task
require 'pony'
namespace :mail do

  desc "Mail Service Reminders"
  task :service_reminder do
    ENV["API_KEYS"].split(",").each do |key|
      Pony.mail(
      :to => key,
      :from => key,
      :subject => 'Bring yer bike in',
      :body => 'Sometime.')
    end
  end

end
