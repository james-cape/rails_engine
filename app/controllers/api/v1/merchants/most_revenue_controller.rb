class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.most_revenue(params[:quantity]))
  end

  #
  # def show
  #   render json: MerchantSerializer.new(Merchant.find(params[:id]))
  # end

end
