module API
  class Base < Grape::API
    mount API::Statistic
    mount API::DocumentApi
  end
end