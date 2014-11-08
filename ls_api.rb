class LsAPI
  require 'net/https'
  require 'json'
  require 'time'

  WorkAlert = Struct.new(:name, :email, :phone, :time_in)

  def initialize(key=ENV["REAL_HUB_KEY"])
    @key = key
    @account_id = get('.json')["Account"]["accountID"]
  end

  def work_alerts_for_upcoming_days(n_days)
    today = Time.now.utc.iso8601
    the_future = (Time.now.utc + (n_days*24*60*60)).iso8601

    # %3E%3C = <>
    get("Workorder.json?timeIn=%3E%3C,#{today},#{the_future}")["Workorder"].map do |wo|

      cust = get("Customer/#{wo["customerID"]}.json?load_relations=all")["Customer"]
      fname = cust['firstName']
      email = cust['Contact']['Emails']['ContactEmail']['address']
      phone = cust['Contact']['Phones']['ContactPhone']['number']

      WorkAlert.new(fname, email, phone, wo['timeIn'])
    end
  end

  private

  def get(path)
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
