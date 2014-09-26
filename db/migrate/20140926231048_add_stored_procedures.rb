class AddStoredProcedures < ActiveRecord::Migration

  def self.up
    views_map.each do |view, proc|
      execute <<-SQL
        CREATE OR REPLACE FUNCTION #{proc} RETURNS void AS $$
        BEGIN
          DROP VIEW IF EXISTS #{view};
          CREATE VIEW #{view} AS
            #{period_types.map {|type| send("select_#{view}", type) }.join('UNION ALL')};
        END; $$
        LANGUAGE PLPGSQL;
      SQL
    end

    StoreProceduresService.new.perform
  end

  def self.down
    views_map.each do |view, proc|
      execute <<-SQL
        DROP VIEW IF EXISTS #{view};
        DROP FUNCTION IF EXISTS #{proc};
      SQL
    end
  end

  private

  def views_map
    StatisticService::STATISTIC_MAP
  end

  def period_types
    StatisticService::PERIOD_TYPES
  end

  def drop_function f_name
    "DROP FUNCTION IF EXISTS #{f_name}();"
  end

  def select_avg_dwell_time_view(type)
    <<-SQL
      SELECT
        date_part('epoch',date_trunc('#{type}',visit_data)) AS date_label,
        round(AVG(a), 2) AS average_dwell_time,
        '#{type}' AS type,
        documents.store_id as store_id
      FROM rows
      INNER JOIN documents ON rows.document_id = documents.id
      GROUP BY documents.store_id, date_trunc('#{type}',visit_data)
    SQL
  end

  def select_unique_visitors_count_view(type)
    <<-SQL
      SELECT DISTINCT
        date_part('epoch', t_1.date_label),
        count(*),
        '#{type}' AS type,
        store_id
      FROM (
        SELECT DISTINCT
          mac_address,
          date_trunc('#{type}',visit_data) AS date_label,
          documents.store_id as store_id
        FROM rows
        INNER JOIN documents ON rows.document_id = documents.id
        GROUP BY documents.store_id, mac_address, date_trunc('#{type}',visit_data)
        ) t_1
      GROUP BY t_1.store_id, t_1.date_label
    SQL
  end

  def select_repeating_visitors_count_view(type)
    <<-SQL
      SELECT DISTINCT
        date_part('epoch', t_1.date_label),
        count(*),
        '#{type}' AS type,
        store_id
      FROM (
        SELECT DISTINCT
          mac_address,
          date_trunc('#{type}',visit_data) AS date_label,
          documents.store_id as store_id
        FROM rows
        INNER JOIN documents ON rows.document_id = documents.id
        GROUP BY documents.store_id, mac_address, date_trunc('#{type}',visit_data)
        HAVING count(mac_address) > 1
        ) t_1
      GROUP BY t_1.store_id, t_1.date_label
    SQL
  end
end
