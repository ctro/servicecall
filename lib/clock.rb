require 'clockwork'
require_relative 'ls_api'
require_relative 'logger'

module Clockwork

  handler do |job|
    Log.blue("Clockwork: running #{job}")
  end

  every(1.minute, 'Sending Reminders', :at => '12:00') {
    l = LsAPI.new
    l.clockwork
  }

end
