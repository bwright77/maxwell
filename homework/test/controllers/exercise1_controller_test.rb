require 'test_helper'

class Exercise1ControllerTest < ActionDispatch::IntegrationTest
  test "should get score" do
    get exercise1_score_url
    assert_response :success
  end

end
