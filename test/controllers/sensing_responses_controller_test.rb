require 'test_helper'

class SensingResponsesControllerTest < ActionController::TestCase

  test "should get create" do
    get :create
    assert_sensing_response :success
  end

end
