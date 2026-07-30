require "test_helper"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  test "renders searchable listings" do
    get properties_url, params: { area: "chanmari", property_type: "apartment" }

    assert_response :success
    assert_includes response.body, properties(:chanmari_flat).title
    assert_not_includes response.body, properties(:hidden_room).title
  end

  test "renders property show and increments views" do
    property = properties(:chanmari_flat)

    assert_difference -> { property.reload.views_count }, 1 do
      get property_url(property)
    end

    assert_response :success
  end

  test "owner can access new listing page" do
    sign_in users(:owner)

    get new_property_url

    assert_response :success
  end
end
