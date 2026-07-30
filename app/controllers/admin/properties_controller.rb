module Admin
  class PropertiesController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_property, only: %i[update destroy]

    def index
      @properties = Property.includes(:user).with_attached_photos.order(created_at: :desc)
    end

    def update
      if @property.update(admin_property_params)
        redirect_to admin_properties_path, notice: "Property updated."
      else
        redirect_to admin_properties_path, alert: @property.errors.full_messages.to_sentence
      end
    end

    def destroy
      @property.destroy
      redirect_to admin_properties_path, notice: "Property removed."
    end

    private

    def set_property
      @property = Property.find(params[:id])
    end

    def admin_property_params
      params.require(:property).permit(:featured, :status)
    end
  end
end
