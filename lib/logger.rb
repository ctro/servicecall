require 'colorize'

module Log
  def self.write(msg, color=nil)
    puts msg.colorize(color) if defined?(LOG) && LOG
  end

  def self.green(msg)
    self.write(msg, :green)
  end
  def self.blue(msg)
    self.write(msg, :blue)
  end
  def self.red(msg)
    self.write(msg, :red)
  end
end
