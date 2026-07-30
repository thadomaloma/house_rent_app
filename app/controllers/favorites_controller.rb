class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @properties = current_user.favorite_properties.visible.with_attached_photos.available_first
  end

  def create
    @property = Property.visible.find(params[:property_id])
    current_user.favorites.find_or_create_by!(property: @property)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: @property, notice: "Saved to favorites." }
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @property = @favorite.property
    @favorite.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: @property, notice: "Removed from favorites." }
    end
  end
end
