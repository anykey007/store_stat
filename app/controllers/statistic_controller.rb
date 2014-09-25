class StatisticController < ApplicationController
  def index
    @sub_domain = params[:sub]
  end
end
