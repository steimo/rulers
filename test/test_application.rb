require_relative "test_helper"

class TestController < Rulers::Controller
  def index
    "Hello!" # Not rendering a view
  end
end

class TestApp < Rulers::Application
  # Overwrites the routing
  def get_controller_and_action(_env)
    [TestController, "index"]
  end
end

class RulersAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    # No matter what is written in #get,
    # the response will always return the #index action from the #TestController
    # because this is hardcoded in the #get_controller_and_action method above.
    get "/some_controller/some_action"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end
end
