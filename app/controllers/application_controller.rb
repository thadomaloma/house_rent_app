class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :admin_user?, :owner_user?, :favorite_for

  private

  def configure_permitted_parameters
    normalize_signup_role
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name phone role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name phone])
  end

  def normalize_signup_role
    return unless params[:user].is_a?(ActionController::Parameters)
    return unless controller_name == "registrations" && action_name == "create"

    params[:user][:role] = "tenant" unless params[:user][:role].in?(%w[tenant owner])
  end

  def authenticate_owner!
    authenticate_user!
    return if current_user.owner_or_admin?

    redirect_to root_path, alert: "Only property owners can access that page."
  end

  def authenticate_admin!
    authenticate_user!
    return if current_user.admin?

    redirect_to root_path, alert: "Admin access is required."
  end

  def admin_user?
    current_user&.admin?
  end

  def owner_user?
    current_user&.owner_or_admin?
  end

  def favorite_for(property)
    return unless user_signed_in?

    current_user.favorites.find { |favorite| favorite.property_id == property.id } ||
      current_user.favorites.find_by(property: property)
  end
end
