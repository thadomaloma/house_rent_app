class DashboardController < ApplicationController
  before_action :authenticate_owner!

  def show
    @properties = current_user.properties.with_attached_photos.order(created_at: :desc)
    @total_views = @properties.sum(:views_count)
    @total_inquiries = Inquiry.joins(:property).where(properties: { user_id: current_user.id }).count
    @recent_inquiries = Inquiry.includes(:property).joins(:property).where(properties: { user_id: current_user.id }).order(created_at: :desc).limit(8)
  end
end
