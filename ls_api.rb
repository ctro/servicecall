module LsAPI
  require 'net/https'
  require 'json'

  # Temp.
  def self.hub_key
    ENV["REAL_HUB_KEY"]
  end

  def self.get(path, qs, key=hub_key)
    http = Net::HTTP.new("api.merchantos.com", 443)
    http.use_ssl = true

    response = http.start do |http|
      request = Net::HTTP::Get.new("/API/#{path}.json?#{qs}")
      request.basic_auth(key, 'apikey')
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def self.account_id(key=hub_key)
    return get("Account", "", key)["Account"]["accountID"]
  end

  def self.workorders(key=hub_key)
    return get("Account/#{account_id}/Workorder", "", key)["Workorder"]
  end

  # TODO: Figure out how to query for dates
  def self.upcoming_workorders(key=hub_key)
    # Time.now.utc.iso8601
    return get("Account/#{account_id}/Workorder", "timeIn>2010", key)["Workorder"]
  end

end
