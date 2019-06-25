require 'csv'

namespace :import do
  desc "Imports specified CSV files from /lib/data"
  task data: :environment do
    `rake db:{drop,create,migrate}`
    puts "Wiping database"

    CSV.foreach('./lib/data/customers.csv', headers: true) do |row|
      Customer.create(row.to_h)
    end
    puts "Imported #{Customer.all.count} customer records"

    CSV.foreach('./lib/data/merchants.csv', headers: true) do |row|
      Merchant.create(row.to_h)
    end
    puts "Imported #{Merchant.all.count} merchant records"

    CSV.foreach('./lib/data/items.csv', headers: true) do |row|
      Item.create(row.to_h)
    end
    puts "Imported #{Item.all.count} item records"

    CSV.foreach('./lib/data/invoices.csv', headers: true) do |row|
      Invoice.create(row.to_h)
    end
    puts "Imported #{Invoice.all.count} invoice records"

    CSV.foreach('./lib/data/transactions.csv', headers: true) do |row|
      Transaction.create(row.to_h)
    end
    puts "Imported #{Transaction.all.count} transaction records"

    CSV.foreach('./lib/data/invoice_items.csv', headers: true) do |row|
      InvoiceItem.create(row.to_h)
    end
    puts "Imported #{InvoiceItem.all.count} invoice_item records"

  end

end
