class LsAPI
  require 'net/https'
  require 'json'
  require 'time'

  WorkAlert = Struct.new(:name, :email, :phone, :time_in) do
    def to_s
      "WorkAlert: name:#{name} email:#{email} phone:#{phone} time_in:#{time_in}"
    end
  end

  def initialize(key=ENV["REAL_HUB_KEY"])
    @key = key
    account = get('.json')["Account"]
    @account_id = account["accountID"]
    @account_name = account["name"]
    Log.blue "API init for #{@account_name}"
  end

  def work_alerts_for_upcoming_days(n_days)
    today = Time.now.utc
    the_future = (Time.now.utc + (n_days*24*60*60))

    Log.blue "Loading Workorders from #{today} to #{the_future}"

    # %3E%3C = <>
    get("Workorder.json?timeIn=%3E%3C,#{today.iso8601},#{the_future.iso8601}")["Workorder"].map do |wo|

      cust = get("Customer/#{wo["customerID"]}.json?load_relations=all")["Customer"]
      fname = cust['firstName']
      email = cust['Contact']['Emails']['ContactEmail']['address']
      phone = cust['Contact']['Phones']['ContactPhone']['number']

      alert = WorkAlert.new(fname, email, phone, wo['timeIn'])
      Log.blue("Found #{alert}")
      return alert
    end
  end

  private

  def get(path)
    Log.blue "GET #{path}"
    http = Net::HTTP.new("api.merchantos.com", 443)
    http.use_ssl = true

    response = http.start do |http|
      request = Net::HTTP::Get.new("/API/Account/#{@account_id}/#{path}")
      request.basic_auth(@key, 'apikey')
      http.request(request)
    end

    JSON.parse(response.body)
  end

end
