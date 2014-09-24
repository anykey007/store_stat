# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'
FactoryGirl.define do
  factory :row do
    visit_data { Faker::Date.between(1.hour.ago, DateTime.current.beginning_of_year) }
    mac_address { Faker::Internet.mac_address('34:15:9e:bb:34') }
    a { Faker::Number.number(2) }
    b { Faker::Number.number(2) }
    c { Faker::Number.number(2) }
    d { Faker::Number.number(2) }
    e { Faker::Number.number(2) }
    f { Faker::Number.number(2) }
    g { Faker::Number.number(2) }
    h { Faker::Number.number(2) }
    association :document, :factory => :document
  end
end
