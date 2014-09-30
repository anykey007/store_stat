class Statistic < ActiveRecord::Base
  belongs_to :store

  def rows
    store.rows.where(visit_data: (beginning_of_period..end_of_period))
  end

  def repeating_visitors_percent
    (100*repeating_visitors_count/unique_visitors_count.to_f).round(2)
  end

  def update_to_latest_data
    if rows.count > 0
      update(avg_dwell_time: new_avg_dwell_time,
             unique_visitors_count: new_unique_visitors_count,
             repeating_visitors_count: new_repeating_visitors_count)
    end
  end

  private

  def new_avg_dwell_time
    time_arr = rows.pluck(:a)
    time_arr.sum.to_f/time_arr.size
  end

  def new_unique_visitors_count
    visitors.uniq.count
  end

  def new_repeating_visitors_count
    visitors.select{ |e| visitors.count(e) > 1 }.uniq.count
  end

  def visitors
    @visitors ||= rows.pluck(:mac_address)
  end

  def beginning_of_period
    period_start.send("beginning_of_#{period_type}")
  end

  def end_of_period
    period_end.send("end_of_#{period_type}")
  end
end
