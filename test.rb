ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require File.expand_path '../servicecall.rb', __FILE__

class ServicecallTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_ping
    get '/ping'
    assert last_response.ok?
    assert_equal "PONG", last_response.body
  end

  def test_info
    get '/info'
    assert last_response.ok?
    assert_match /Key Length: /, last_response.body
  end


end
