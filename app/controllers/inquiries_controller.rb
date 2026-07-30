class InquiriesController < ApplicationController
  def create
    @property = Property.visible.find(params[:inquiry][:property_id])
    @inquiry = @property.inquiries.new(inquiry_params)
    @inquiry.user = current_user if user_signed_in?

    if @inquiry.save
      redirect_to @property, notice: "Inquiry sent to #{@property.contact_name}."
    else
      redirect_to @property, alert: @inquiry.errors.full_messages.to_sentence
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :phone, :message)
  end
end
