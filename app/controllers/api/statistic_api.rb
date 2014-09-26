module API
  class StatisticApi < Grape::API
    # Set all output formats to json
    # NOTE: always functions should return hash!!!
    format :json

    resource :statistic do
      before do
        @ss = StatisticService.new(sub_domain: params[:sub])
      end

      get :average_dwell_time do
        @ss.average_dwell_time
      end

      get :unique_visitors do
        @ss.unique_visitors_count
      end

      get :repeating_visitors do
        @ss.repeating_visitors_percent
      end

      get :all do
        { average_dwell_time: @ss.average_dwell_time,
          unique_visitors_count: @ss.unique_visitors_count,
          repeating_visitors_percent: @ss.repeating_visitors_percent
        }
      end
    end
  end
end
