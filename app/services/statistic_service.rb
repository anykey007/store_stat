class StatisticService
  PERIOD_TYPES    = ['month', 'week', 'day']
  STATISTIC_NAMES = ['avg_dwell_time', 'unique_visitors_count', 'repeating_visitors_count']
  VIEW_NAME       = STATISTIC_NAMES.map { |name| "#{name}_view" }
  PROC_NAMES      = STATISTIC_NAMES.map { |name| "create_#{name}_view()" }
  STATISTIC_MAP   = Hash[VIEW_NAME.zip PROC_NAMES]

  attr_reader :document_ids, :sub_domain

  def initialize opts = {}
    @document_ids   = opts[:document_ids] || []
    @sub_domain     = opts[:sub_domain] || 'month'
  end

  def average_dwell_time
    query = <<-SQL
      SELECT date_label, average_dwell_time
      FROM avg_dwell_time_view
      WHERE #{where_condition}
    SQL
    build_responce(select_rows(query))
  end

  def unique_visitors_count
    query = <<-SQL
      SELECT date_part, count
      FROM unique_visitors_count_view
      WHERE #{where_condition}
    SQL
    build_responce(select_rows(query))
  end

  def repeating_visitors_count
    query = <<-SQL
      SELECT date_part, count
      FROM repeating_visitors_count_view
      WHERE #{where_condition}
    SQL
    build_responce(select_rows(query))
  end

  def repeating_visitors_percent
    unique_visitors    = unique_visitors_count
    repeating_visitors = repeating_visitors_count
    repeating_visitors.update(repeating_visitors){|key,v1| (100*v1/unique_visitors[key]).round(2)}
  end

  private

  def where_condition
    "type = '#{@sub_domain}'"
  end

  def select_values(*args)
    ActiveRecord::Base.connection.select_values(sanitize_sql(args))
  end

  def select_rows(*args)
    ActiveRecord::Base.connection.select_rows(sanitize_sql(args))
  end

  def sanitize_sql(array)
    ActiveRecord::Base.send(:sanitize_sql_array, array)
  end

  def build_responce data
    result = Hash[data]
    result.update(result){|key,v1| v1.to_f}
  end
end
