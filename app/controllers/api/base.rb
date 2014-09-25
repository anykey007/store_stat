module API
  class Base < Grape::API
    mount API::Statistic
  end
end