class StatisticController < ApplicationController
  def index
    @sub_domain              = params[:sub]
    ss                       = StatisticService.new(sub_domain: @sub_domain)
    @average_dwell_time      = ss.average_dwell_time
    @unique_visitors_count   = ss.unique_visitors_count
    @repeating_visitors_data = ss.repeating_visitors_percent
  end
end
