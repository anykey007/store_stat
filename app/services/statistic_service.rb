class StatisticService
  attr_reader :document_ids, :sub_domain

  def initialize opts = {}
    @document_ids   = opts[:document_ids] || []
    @sub_domain     = opts[:sub_domain] || 'month'
  end

  def average_dwell_time
    query = <<-SQL
      SELECT #{date_part(date_trunc)} AS date_label,
        #{pg_round('AVG(a)', 2)} AS average_dwell_time
      FROM rows
      WHERE #{where_condition}
      GROUP BY #{date_trunc}
    SQL
    build_responce(select_rows(query))
  end

  def unique_visitors_count
    query = <<-SQL
      SELECT DISTINCT
        #{date_part('t_1.date_label')},
        count(*)
      FROM (
        SELECT DISTINCT
          mac_address,
          #{date_trunc} AS date_label
        FROM rows
        WHERE #{where_condition}
        GROUP BY mac_address, #{date_trunc}
        ) t_1
      GROUP BY t_1.date_label
    SQL
    build_responce(select_rows(query))
  end

  def repeating_visitors_count
    query = <<-SQL
      SELECT DISTINCT
        #{date_part('t_1.date_label')},
        count(*)
      FROM (
        SELECT mac_address, #{date_trunc} AS date_label
        FROM rows
        WHERE #{where_condition}
        GROUP BY mac_address, #{date_trunc}
        HAVING count(mac_address) > 1
      ) t_1
      GROUP BY t_1.date_label
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
    @document_ids.any? ? "document_id IN (#{@document_ids.join(',')})": "TRUE"
  end

  def date_trunc
    "date_trunc('#{@sub_domain}',visit_data)"
  end

  def date_part value
    "date_part('epoch',#{value})"
  end

  def pg_round(value, places)
    "round(#{value}, #{places})"
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
