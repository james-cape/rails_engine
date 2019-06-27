class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    render json: InvoiceSerializer.new(Merchant.revenue(params[:date]))
  end

end
