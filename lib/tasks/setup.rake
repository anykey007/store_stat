require 'factory_girl'
require 'faker'
task setup: :environment do
  rows_count = ENV['ROWS_COUNT'].to_i || 1_000
  raise "Please put rows count not more than 100.000" if rows_count > 100_000

  store = FactoryGirl.create(:store)
  document = FactoryGirl.create(:document, store: store)
  FactoryGirl.create_list(:row, rows_count, document: document)
  UpdateStatisticService.new(document).perform
end
