class StatisticService
  attr_reader :store, :sub_domain

  def initialize store, opts = {}
    @store        = store
    @sub_domain   = opts[:sub_domain] || 'month'
  end

  def average_dwell_time
   build_responce(records.map{ |r| [r.period_start.strftime('%s'), r.avg_dwell_time.round(2)] })
  end

  def unique_visitors_count
    build_responce(records.map{ |r| [r.period_start.strftime('%s'), r.unique_visitors_count] })
  end

  def repeating_visitors_count
    build_responce(records.map{ |r| [r.period_start.strftime('%s'), r.repeating_visitors_count] })
  end

  def repeating_visitors_percent
    build_responce(records.map{ |r| [r.period_start.strftime('%s'), r.repeating_visitors_percent] })
  end

  private

  def records
    @records ||= @store.statistics.where(period_type: @sub_domain)
  end

  def build_responce data
    result = Hash[data]
    result.update(result){|key,v1| v1.to_f}
  end
end
