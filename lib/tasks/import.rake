namespace :import do
  desc "TODO"
  task data: :environment do
    CSV.foreach('./lib/data/customers.csv', headers: true) do |row|
      Data.create(row.to_h)
    end
  end

end
