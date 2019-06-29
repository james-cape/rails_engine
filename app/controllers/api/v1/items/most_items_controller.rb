class Api::V1::Items::MostItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.items_by_most_sold(params[:quantity].to_i))
  end
end
