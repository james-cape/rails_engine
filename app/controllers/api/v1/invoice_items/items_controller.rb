class Api::V1::InvoiceItems::ItemsController < ApplicationController
  def show
    # render json: InvoiceSerializer.new(Invoice.where(customer_id: params[:id]))
    render json: ItemSerializer.new(InvoiceItem.find(params[:id]).item)
  end
end
