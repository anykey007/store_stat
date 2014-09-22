require 'rails_helper'

RSpec.describe StatisticService, :type => :model do
  let!(:document) { create :document }
  let!(:mac_address_1) { '34:15:9e:bb:34:7f' }
  let!(:mac_address_2) { '34:15:9e:bb:34:6f' }
  let!(:mac_address_3) { '34:15:9e:bb:34:5f' }
  let!(:rows) { create_list :row, 8, document: document, mac_address: mac_address_1 }
  subject { StatisticService.new }

  describe "#average_dwell_time" do
    it 'counts avarage value', :focus=>true do
      expect(subject.average_dwell_time).to eq(rows.map(&:a).sum/rows.count)
    end
  end

  describe "#unique_visitors_count" do
    before do
      rows[0].update_attribute(:mac_address, mac_address_2)
      rows[1].update_attribute(:mac_address, mac_address_3)
    end
    it 'counts unique visitors', :focus=>true do
      expect(subject.unique_visitors_count).to eq(3)
    end
  end

  context 'Repeating visitors' do
    before do
      rows[0].update_attribute(:mac_address, mac_address_2)
      rows[1].update_attribute(:mac_address, mac_address_2)

      rows[2].update_attribute(:mac_address, mac_address_3)
      rows[3].update_attribute(:mac_address, mac_address_3)

      rows[4].update_attribute(:mac_address, '34:15:9e:bb:34:4f')
    end

    describe "#repeating_visitors" do
      it 'returns repeating visitors', :focus=>true do
        expect(subject.send(:repeating_visitors).map(&:mac_address)).to match_array(
          [mac_address_1, mac_address_2, mac_address_3])
      end
    end

    describe "#repeating_visitors_count" do
      it 'returns count of repeating visitors', :focus=>true do
        expect(subject.send(:repeating_visitors_count)).to eq(3)
      end
    end

    describe '#repeating_visitors_percent' do
      it 'returns percent of repeating visitors', :focus=>true do
        expect(subject.repeating_visitors_percent).to eq(0.75)
      end
    end
  end
end
