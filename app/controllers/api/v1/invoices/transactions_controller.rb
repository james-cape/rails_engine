class Api::V1::Invoices::TransactionsController < ApplicationController
  def index
    ##########
    # Doesn't pass test
    # test_loads_a_collection_of_transactions_associated_with_one_invoice
    render json: TransactionSerializer.new(Invoice.find(params[:id]).transactions)
  end
end
