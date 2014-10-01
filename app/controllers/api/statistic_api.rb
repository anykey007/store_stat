module API
  class StatisticApi < Grape::API
    # Set all output formats to json
    # NOTE: always functions should return hash!!!
    format :json

    resource :statistic do
      before do
        store = Store.find(params[:store_id])
        @statistic_service = StatisticService.new(store, sub_domain: params[:sub_domain])
      end

      get :average_dwell_time do
        @statistic_service.average_dwell_time
      end

      get :unique_visitors do
        @statistic_service.unique_visitors_count
      end

      get :repeating_visitors do
        @statistic_service.repeating_visitors_percent
      end

      get :all do
        { average_dwell_time: @statistic_service.average_dwell_time,
          unique_visitors_count: @statistic_service.unique_visitors_count,
          repeating_visitors_percent: @statistic_service.repeating_visitors_percent
        }
      end
    end
  end
end
