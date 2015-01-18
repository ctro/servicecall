class LsAPI
  require 'net/https'
  require 'json'
  require 'time'
  require 'logger'

  attr_accessor :key, :account_id, :account_name, :work_alerts

  WorkAlert = Struct.new(:name, :email, :phone, :time_in) do
    def to_s
      "WorkAlert: name:#{name} email:#{email} phone:#{phone} time_in:#{localtime}"
    end

    def localtime
      Time.parse(time_in).localtime.strftime("%m/%d/%Y at %I:%M%p")
    end
  end

  def initialize(key=ENV["REAL_HUB_KEY"])
    @key = key
    account = get('.json')["Account"]
    @account_id = account["accountID"]
    @account_name = account["name"]
    @work_alerts = []
    Log.blue "API init for #{@account_name}"
  end

  def clockwork(days_out=10)
    alerts = work_alerts_for_upcoming_days(days_out.to_i)
    body = alerts.map{ |a| "#{a}\n\n" }

    Log.green("Sending alerts...")

    message = Pony.mail(:to => "clint@ctro.net", :from => "clint@ctro.net",
    :subject => "I think these people are coming in the next #{days_out} days",
    :body => body)

    Log.green(message.to_s)
    "OK"
  end

  def work_alerts_for_upcoming_days(n_days)
    today = Time.now.utc
    the_future = (Time.now.utc + Time.days(n_days))

    Log.blue "Loading Workorders from #{today} to #{the_future}"

    # %3E%3C = <>
    url = "Workorder.json?timeIn=%3E%3C,#{today.iso8601},#{the_future.iso8601}"

    begin
      @response = get(url)
      @response.fetch("Workorder").each do |wo|

        cust = get("Customer/#{wo["customerID"]}.json?load_relations=all")["Customer"]
        fname = cust['firstName']
        email = cust['Contact']['Emails']['ContactEmail']['address'] rescue "N/A"
        phone = cust['Contact']['Phones']['ContactPhone']['number'] rescue "N/A"

        alert = WorkAlert.new(fname, email, phone, wo['timeIn'])
        Log.blue("Found #{alert}")

        @work_alerts << alert
      end
    rescue KeyError => e
      Log.red "No workorders found..."
      Log.red "Rescued: #{e.to_s}"
      Log.red "From: #{@response.to_s}"
    end


    return @work_alerts
  end

  private

  def get(path)
    url = "https://#{@key}:apikey@api.merchantos.com/API/Account/#{@account_id}/#{path}"
    Log.blue "GET #{url}"
    response = HTTParty.get(url)

    Log.green response.body
    JSON.parse(response.body)
  end

end
