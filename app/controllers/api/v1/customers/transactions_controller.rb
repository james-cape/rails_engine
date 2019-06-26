class Api::V1::Customers::TransactionsController < ApplicationController
  def index
    # render json: TransactionSerializer.new(Transaction.where(customer_id: params[:id]))
    render json: TransactionSerializer.new(Customer.find(params[:id]).transactions)
    ##########################
    #### Why is this not passing ruby test/relationships/customer_relationship_test.rb --name test_loads_a_collection_of_transaction_associated_with_one_customer
    # --- expected
    # +++ actual
    # @@ -1 +1 @@
    # -["credit_card_number", "id", "invoice_id", "result"]
    # +["credit_card_expiration_date", "credit_card_number", "id", "invoice_id", "result"]
    ###########################
  end
end
