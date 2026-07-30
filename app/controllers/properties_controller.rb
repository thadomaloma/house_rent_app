class PropertiesController < ApplicationController
  before_action :authenticate_owner!, except: %i[index show]
  before_action :set_property, only: %i[show edit update destroy]
  before_action :authorize_property_owner!, only: %i[edit update destroy]

  def index
    @properties = Property.search(search_params).with_attached_photos
  end

  def show
    @property.increment!(:views_count)
    @inquiry = Inquiry.new(
      name: current_user&.name,
      phone: current_user&.phone
    )
  end

  def new
    @property = current_user.properties.new(
      contact_name: current_user.name,
      phone: current_user.phone,
      available_from: Date.current
    )
  end

  def create
    @property = current_user.properties.new(property_params)

    if @property.save
      redirect_to @property, notice: "Your listing is live on Inluah."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @property.update(property_params)
      redirect_to @property, notice: "Listing updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to dashboard_path, notice: "Listing deleted."
  end

  private

  def set_property
    @property = if action_name == "show" && !admin_user?
      Property.visible.find(params[:id])
    else
      Property.find(params[:id])
    end
  end

  def authorize_property_owner!
    return if admin_user? || @property.user == current_user

    redirect_to dashboard_path, alert: "You can only manage your own listings."
  end

  def property_params
    params.require(:property).permit(
      :title,
      :description,
      :property_type,
      :rent,
      :deposit,
      :area,
      :address,
      :bedrooms,
      :bathrooms,
      :floor,
      :available_from,
      :contact_name,
      :phone,
      :whatsapp_number,
      :status,
      photos: []
    )
  end

  def search_params
    params.permit(:q, :area, :property_type, :min_rent, :max_rent, :bedrooms)
  end
end
