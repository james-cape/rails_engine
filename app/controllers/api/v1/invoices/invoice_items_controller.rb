class Api::V1::Invoices::InvoiceItemsController < ApplicationController
  def index
    render json: InvoiceItemSerializer.new(Invoice.find(params[:id]).invoice_items.order('invoice_items.id'))
  end
end
