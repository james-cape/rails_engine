class Api::V1::Invoices::InvoiceItemsController < ApplicationController
  def index
    ####### Why doesn't the commented-out code work?
    # render json: InvoiceItemSerializer.new(Invoice.find(params[:id]).invoice_items)
    render json: InvoiceItemSerializer.new(InvoiceItem.where(invoice_id: params[:id]))
  end
end
