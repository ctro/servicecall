ENV['RACK_ENV'] = 'test'
require 'rack/test'
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'timecop'
require_relative '../servicecall.rb'

class ServicecallTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def fixture(name)
    File.read(File.expand_path("fixtures/#{name}.json", File.dirname(__FILE__)))
  end

  def mock_request(url, response_body)
    stub_request(:get, url).
    to_return(:status => 200, :body => response_body, :headers => {})
  end

  def mock_account
    mock_request(
      "https://test-api-key:apikey@api.merchantos.com/API/Account//.json",
      fixture('account'))
  end

  def mock_workorders
    tin = Time.now.utc.iso8601
    tout = (Time.now.utc + Time.days(10)).iso8601
    mock_request(
      "https://test-api-key:apikey@api.merchantos.com/API/Account/22422/Workorder.json?timeIn=%3E%3C,#{tin},#{tout}",
      fixture('workorders'))
  end

  def mock_customer(id)
    mock_request(
      "https://test-api-key:apikey@api.merchantos.com/API/Account/22422/Customer/#{id}.json?load_relations=all",
      fixture("customer_#{id}"))
  end


  #############
  ### TESTS ###
  #############

  def test_work_alert_struct
    name = 'Clint Troxel'
    email = 'clint@ctro.net'
    phone = '307-413-0366'
    time_in = Time.now + Time.days(7)

    w = LsAPI::WorkAlert.new(name, email, phone, time_in)

    assert_equal(name, w.name)
    assert_equal(email, w.email)
    assert_equal(phone, w.phone)
    assert_equal(time_in, w.time_in)
  end

  def test_ping_handler
    get '/ping'
    assert last_response.ok?
    assert_equal "PONG", last_response.body
  end

  def test_index
    get '/'
    assert last_response.ok?
    assert_match /Hello, world!/, last_response.body
  end

  def test_ls_api_client
    Timecop.freeze(Time.now) do

      mock_account
      mock_workorders
      mock_customer(3492)
      mock_customer(4366)
      mock_customer(5032)
      mock_customer(5034)

      lsapi = LsAPI.new('test-api-key')

      assert_equal 'The Test Bicycle Service', lsapi.account_name
      assert_equal '22422', lsapi.account_id

      work_alerts = lsapi.work_alerts_for_upcoming_days(10)

      assert_equal 4, work_alerts.size
      work_alerts.each{ |wa| assert wa.is_a?(LsAPI::WorkAlert)}

      wa = work_alerts.first
      assert_equal 'Elena', wa.name
      assert_equal 'ealarcon55@yahoo.com', wa.email
      assert_equal 'N/A', wa.phone
      assert Time.parse(wa.time_in)
    end
  end

end
