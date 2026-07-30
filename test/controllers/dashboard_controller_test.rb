require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "owner can view dashboard" do
    sign_in users(:owner)

    get dashboard_url

    assert_response :success
    assert_includes response.body, "Owner dashboard"
  end
end
