module API
  class Base < Grape::API
    mount API::StatisticApi
    mount API::DocumentApi
  end
end