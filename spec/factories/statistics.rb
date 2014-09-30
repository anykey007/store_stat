# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :statistic do
    association :store, :factory => :document
    period_start "2014-09-29 17:02:46"
    period_end "2014-09-29 17:02:46"
    avg_dwell_time 1.5
    unique_visitors_count 3
    repeating_visitors_count 2
    period_type "month"
  end
end
