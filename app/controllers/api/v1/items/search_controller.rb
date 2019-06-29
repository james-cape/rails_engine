class Api::V1::Items::SearchController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.where(search_params).order(:id).first)
  end

  def index
    render json: ItemSerializer.new(Item.where(search_params).order(:id))
  end

  private

  def search_params
    params[:unit_price] = (params[:unit_price].to_r * 100) if params[:unit_price]
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
