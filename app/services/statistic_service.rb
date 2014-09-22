class StatisticService
  attr_reader :document_ids, :rows_to_select

  def initialize document_ids = []
    @document_ids   = document_ids
    @rows_to_select = document_ids.any? ? Row.where(document_id: document_ids) : Row.unscoped
  end

  def average_dwell_time
    @rows_to_select.average(:a)
  end

  def unique_visitors_count
    @rows_to_select.select(:mac_address).distinct.count
  end

  def repeating_visitors_percent
    repeating_visitors_count.to_f/unique_visitors_count.to_f
  end

  private

  def repeating_visitors
    @rows_to_select.
      select("mac_address, count(mac_address) as repeating_visitors").
      group("mac_address").
      having("count(mac_address) > ?", 1)
  end

  def repeating_visitors_count
    @rows_to_select.select('result.*').from(repeating_visitors, :result).count
  end
end
