class StatisticController < ApplicationController
  before_action :set_sub_domain

  def index
  end

  def stat_tables
    render :layout => 'tables'
  end

  private

  def set_sub_domain
    @sub_domain = params[:sub] || 'month'
  end
end
