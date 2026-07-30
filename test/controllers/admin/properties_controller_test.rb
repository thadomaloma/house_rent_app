require "test_helper"

class Admin::PropertiesControllerTest < ActionDispatch::IntegrationTest
  test "admin can manage properties" do
    sign_in users(:admin)

    get admin_properties_url

    assert_response :success
    assert_includes response.body, properties(:chanmari_flat).title
  end

  test "admin can feature a property" do
    sign_in users(:admin)
    property = properties(:hidden_room)

    patch admin_property_url(property), params: { property: { featured: "1", status: "available" } }

    assert_redirected_to admin_properties_url
    assert property.reload.featured?
    assert property.available?
  end
end
