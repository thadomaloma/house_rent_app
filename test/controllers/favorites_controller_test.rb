require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  test "user can create favorite" do
    sign_in users(:owner)

    assert_difference "Favorite.count", 1 do
      post favorites_url, params: { property_id: properties(:chanmari_flat).id }
    end

    assert_redirected_to property_url(properties(:chanmari_flat))
  end

  test "user can remove favorite" do
    sign_in users(:tenant)

    assert_difference "Favorite.count", -1 do
      delete favorite_url(favorites(:saved_flat))
    end
  end
end
