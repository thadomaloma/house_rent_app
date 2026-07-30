class HomeController < ApplicationController
  def index
    @featured_properties = Property.visible.featured.with_attached_photos.available_first.limit(6)
    @latest_properties = Property.visible.with_attached_photos.available_first.limit(8)
    @popular_areas = %w[chanmari dawrpui ramhlun bawngkawn vaivakawn kulikawn durtlang zemabawk]
  end
end
