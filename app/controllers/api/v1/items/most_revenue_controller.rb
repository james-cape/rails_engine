class Api::V1::Items::MostRevenueController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.items_by_most_revenue(params[:quantity].to_i))
  end
end
