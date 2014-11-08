module Log
  require 'colorize'

  def self.write(msg, color=nil)
    puts(msg.colorize(color))
  end

  def self.green(msg)
    self.write(msg, :green)
  end
  def self.blue(msg)
    self.write(msg, :blue)
  end
end
