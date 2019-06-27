class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    render json: CentsDollarsSerializer.new(Invoice.revenue(params[:date]))
  end

end
