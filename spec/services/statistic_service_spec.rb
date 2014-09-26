require 'rails_helper'

RSpec.describe StatisticService, :type => :model do
  let!(:document) { create :document }
  let!(:mac_address_1) { '34:15:9e:bb:34:7f' }
  let!(:mac_address_2) { '34:15:9e:bb:34:6f' }
  let!(:mac_address_3) { '34:15:9e:bb:34:5f' }

  let!(:sep_23_2014) { DateTime.parse('Wed, 23 Sep 2014 14:59:01 +0000') }
  let!(:sep_22_2014) { DateTime.parse('Tue, 22 Sep 2014 14:59:01 +0000') }
  let!(:sep_16_2014) { DateTime.parse('Tue, 16 Sep 2014 14:59:01 +0000') }
  let!(:sep_09_2014) { DateTime.parse('Tue, 09 Sep 2014 14:59:01 +0000') }
  let!(:aug_22_2014) { DateTime.parse('Sat, 22 Aug 2014 14:59:01 +0000') }
  let!(:jul_22_2014) { DateTime.parse('Wed, 22 Jul 2014 14:59:01 +0000') }
  let!(:sep_22_2013) { DateTime.parse('Mon, 23 Sep 2013 14:59:01 +0000') }
  let!(:sep_22_2012) { DateTime.parse('Sun, 23 Sep 2012 14:59:01 +0000') }

  let!(:month_keys) do
    [sep_23_2014, aug_22_2014, jul_22_2014, sep_22_2013, sep_22_2012].map do |date|
      date.beginning_of_month.strftime('%s')
    end
  end
  let!(:week_keys) do
    [sep_23_2014, sep_16_2014, sep_09_2014, aug_22_2014,
     jul_22_2014, sep_22_2013, sep_22_2012].map do |date|
      date.beginning_of_week.strftime('%s')
    end
  end

  let!(:sep_week1_rows) do
    rows = []
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: sep_23_2014)
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: sep_23_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: sep_23_2014)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_23_2014)

    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: sep_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: sep_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: sep_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_22_2014)
    rows
  end

  let!(:sep_week2_rows) do
    rows = []
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: sep_16_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: sep_16_2014)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_16_2014)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_16_2014)
    rows
  end

  let!(:sep_week3_rows) do
    rows = []
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: sep_09_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: sep_09_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: sep_09_2014)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_09_2014)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_09_2014)
    rows
  end

  let!(:sep_2014_rows) do
    rows = sep_week1_rows + sep_week2_rows + sep_week3_rows
  end

  let!(:aug_2014_rows) do
    rows = []
    rows << create(:row, document: document,                             visit_data: aug_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: aug_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: aug_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: aug_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: aug_22_2014)
    rows
  end

  let!(:jul_2014_rows) do
    rows = []
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: jul_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: jul_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: jul_22_2014)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: jul_22_2014)
    rows
  end

  let!(:sep_2013_rows) do
    rows = []
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: sep_22_2013)
    rows << create(:row, document: document, mac_address: mac_address_2, visit_data: sep_22_2013)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_22_2013)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_22_2013)
    rows
  end

  let!(:sep_2012_rows) do
    rows = []
    rows << create(:row, document: document, mac_address: mac_address_1, visit_data: sep_22_2012)
    rows << create(:row, document: document, mac_address: mac_address_3, visit_data: sep_22_2012)
    rows
  end

  let!(:monthly_rows) { [sep_2014_rows, aug_2014_rows, jul_2014_rows, sep_2013_rows, sep_2012_rows] }
  let!(:weekly_rows)  { [sep_week1_rows, sep_week2_rows, sep_week3_rows, aug_2014_rows,
                         jul_2014_rows, sep_2013_rows, sep_2012_rows] }

  let!(:monthly_statistic) { StatisticService.new(sub_domain: 'month') }
  let!(:week_statistic)  { StatisticService.new(sub_domain: 'week')  }
  let!(:perform) { StoreProceduresService.new.perform }

  describe "#average_dwell_time" do
    it 'counts avarage values grouped by month', :focus=>true do
      expected_values = monthly_rows.map { |rows| average(rows) }
      expect(monthly_statistic.average_dwell_time).to eq(monthly_values(expected_values))
    end

    it 'counts avarage values grouped by week', :focus=>true do
      expected_values = weekly_rows.map { |rows| average(rows) }
      expect(week_statistic.average_dwell_time).to eq(weekly_values(expected_values))
    end
  end

  describe "#unique_visitors_count" do
    it 'counts unique visitors grouped by month', :focus=>true do
      expected_values = monthly_rows.map { |rows| unique_visitors_count(rows) }
      expect(monthly_statistic.unique_visitors_count).to eq(monthly_values(expected_values))
    end

    it 'counts unique visitors grouped by week', :focus=>true do
      expected_values = weekly_rows.map { |rows| unique_visitors_count(rows) }
      expect(week_statistic.unique_visitors_count).to eq(weekly_values(expected_values))
    end
  end

  context 'Repeating visitors' do
    describe "#repeating_visitors_count" do
      it 'returns count of repeating visitors grouped by month', :focus=>true do
        expected_values = monthly_rows.map { |rows| repeating_visitors_count(rows) }
        expected_hash   = period_values_without_zeros(monthly_values(expected_values))
        expect(monthly_statistic.send(:repeating_visitors_count)).to eq(expected_hash)
      end

      it 'returns count of repeating visitors grouped by week', :focus=>true do
        expected_values = weekly_rows.map { |rows| repeating_visitors_count(rows) }
        expected_hash   = period_values_without_zeros(weekly_values(expected_values))
        expect(week_statistic.send(:repeating_visitors_count)).to eq(expected_hash)
      end
    end

    describe '#repeating_visitors_percent' do
      it 'returns percent of repeating visitors grouped by month', :focus=>true do
        expected_values = monthly_rows.map { |rows| repeating_visitors_percent(rows) }
        expect(monthly_statistic.repeating_visitors_percent).to eq(monthly_values(expected_values))
      end

      it 'returns count of repeating visitors grouped by week', :focus=>true do
        expected_values = weekly_rows.map { |rows| repeating_visitors_percent(rows) }
        expect(week_statistic.repeating_visitors_percent).to eq(weekly_values(expected_values))
      end
    end
  end

  private

  def average arr
    (arr.map(&:a).sum/arr.size.to_f).round(2)
  end

  def unique_visitors_count arr
    arr.map(&:mac_address).uniq.size
  end

  def repeating_visitors_count arr
    arr = arr.map(&:mac_address)
    arr.select{ |e| arr.count(e) > 1 }.uniq.count
  end

  def repeating_visitors_percent arr
    (100*repeating_visitors_count(arr)/unique_visitors_count(arr).to_f).round(2)
  end

  # need for testing repeating visitors count
  # DB query do not selects values contained zeros
  def period_values_without_zeros hash
    hash.select { |key, value| value > 0 }
  end

  def monthly_values values
    Hash[month_keys.zip values]
  end

  def weekly_values values
    Hash[week_keys.zip values]
  end
end
