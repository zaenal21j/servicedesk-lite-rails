require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in }

  test "should get index" do
    get root_url
    assert_response :success
  end
end
