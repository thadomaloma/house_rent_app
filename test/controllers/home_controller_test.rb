require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "renders landing page" do
    get root_url

    assert_response :success
    assert_includes response.body, "Inluah"
  end
end
