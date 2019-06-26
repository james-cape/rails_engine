class Api::V1::InvoiceItems::InvoicesController < ApplicationController
  def show
    # render json: InvoiceSerializer.new(Invoice.where(customer_id: params[:id]))
    render json: InvoiceSerializer.new(InvoiceItem.find(params[:id]).invoice)
  end
end
