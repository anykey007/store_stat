class UpdateStatisticService
  PERIOD_TYPES = ['month', 'week', 'day']

  attr_reader :document, :store

  def initialize document
    @document = document
    @store    = document.store
  end

  def perform
    raise "Document haven't rows" if rows.count == 0

    PERIOD_TYPES.each do |period_type|
      update_for_period period_type
    end
  end

  private

  def update_for_period period_type
    date_points(period_type).each do |date|
      statistic = store.statistics.find_or_initialize_by(
        :period_start => date[0],
        :period_end   => date[1],
        :period_type  => period_type)
      statistic.update_to_latest_data
    end
  end

  def date_points period_type
    visit_dates.map do |date|
      [beginning_of_period(date, period_type), end_of_period(date, period_type)]
    end.uniq
  end

  def rows
    @rows ||= document.rows
  end

  def visit_dates
    @visit_dates ||= rows.map(&:visit_data)
  end

  def beginning_of_period date, period_type
    date.send("beginning_of_#{period_type}")
  end

  def end_of_period date, period_type
    date.send("end_of_#{period_type}")
  end
end