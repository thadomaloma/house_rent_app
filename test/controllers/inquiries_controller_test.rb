require "test_helper"

class InquiriesControllerTest < ActionDispatch::IntegrationTest
  test "guest can submit inquiry" do
    assert_difference "Inquiry.count", 1 do
      post inquiries_url, params: {
        inquiry: {
          property_id: properties(:chanmari_flat).id,
          name: "Guest",
          phone: "+919612300009",
          message: "Can I view this?"
        }
      }
    end

    assert_redirected_to property_url(properties(:chanmari_flat))
  end
end
