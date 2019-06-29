class Api::V1::Items::BestDayController < ApplicationController
  def show
    render json: DateSerializer.new(Item.find(params[:id]).find_best_day)
  end


end
