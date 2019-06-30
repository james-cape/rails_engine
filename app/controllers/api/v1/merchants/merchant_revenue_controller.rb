class Api::V1::Merchants::MerchantRevenueController < ApplicationController
  def show
    if params[:date]
      render json: RevenueCentsDollarsSerializer.new(Merchant.find(params[:id]).transactions_revenue(params[:date]))
    else
      render json: RevenueCentsDollarsSerializer.new(Merchant.find(params[:id]).transactions_revenue)
    end
  end

end
