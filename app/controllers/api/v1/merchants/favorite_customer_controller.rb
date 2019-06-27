class Api::V1::Merchants::MostRevenueController < ApplicationController
  def show
    render json: CustomerSerializer.new(Merchant.favorite_customer)
  end

end
