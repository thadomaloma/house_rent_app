module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
      @properties_count = Property.count
      @users_count = User.count
      @hidden_count = Property.hidden.count
      @inquiries_count = Inquiry.count
      @recent_properties = Property.includes(:user).order(created_at: :desc).limit(6)
    end
  end
end
