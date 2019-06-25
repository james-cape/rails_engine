require 'csv'

namespace :import do
  desc "TODO"
  task data: :environment do
    CSV.foreach('./lib/data/customers.csv', headers: true) do |row|
      Customer.create(row.to_h)
    end
    puts "Imported #{Customer.all.count} customer records"
  end

end
