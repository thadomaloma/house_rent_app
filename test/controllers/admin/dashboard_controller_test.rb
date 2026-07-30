require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "admin can view dashboard" do
    sign_in users(:admin)

    get admin_root_url

    assert_response :success
    assert_includes response.body, "control room"
  end
end
