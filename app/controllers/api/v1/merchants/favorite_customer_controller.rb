class Api::V1::Merchants::FavoriteCustomerController < ApplicationController
  def show
    render json: CustomerSerializer.new(Merchant.find(params[:id]).favorite_customer)
  end
end
