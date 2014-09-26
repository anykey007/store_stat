class StoreProceduresService
  def perform
    ActiveRecord::Base.connection.
      execute(StatisticService::PROC_NAMES.map { |p_name| "SELECT #{p_name};"}.join)
  end
end