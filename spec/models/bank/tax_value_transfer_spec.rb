require 'rails_helper'

RSpec.describe ::Bank::TaxValueTransfer do
  describe '.get' do
    context 'when time is business hours and value is less than 1000' do
      let(:begin_time_to_tax) { Time.zone.now.beginning_of_week.change({ hour: 9, min: 0, sec: 0 }) }
      let(:end_time_to_tax) { Time.zone.now.end_of_week.change({ hour: 18, min: 0, sec: 0 }) - 2.day }
      let(:rand_begin_end_time) { Time.zone.now.beginning_of_week.change({ hour: 18, min: 0, sec: 0 }) }

      it 'expect tax value be 5(five) at 9am' do
        calculator = described_class.new
        value = rand(1...999)

        expect(calculator.get(value:, time: begin_time_to_tax)).to eq(5)
      end

      it 'expect tax value be 5(five) at 6pm' do
        calculator = described_class.new
        value = rand(1...999)

        expect(calculator.get(value:, time: begin_time_to_tax)).to eq(5)
      end

      it 'expect tax value be 5(five) between 9am to 6pm' do
        calculator = described_class.new
        value = rand(1...999)

        expect(calculator.get(value:, time: rand_begin_end_time)).to eq(5)
      end
    end

    context 'when time is out of business hours and value is less than 1000' do
      let(:start_sunday) { Time.zone.now.end_of_week.change({ hour: 0, min: 0, sec: 0 }) }
      let(:end_sunday) { Time.zone.now.end_of_week.change({ hour: 23, min: 59, sec: 59 }) }
      let(:rand_sunday) { rand(start_sunday..end_sunday) }

      let(:start_saturday) { Time.zone.now.end_of_week.change({ hour: 0, min: 0, sec: 0 }) - 1.day }
      let(:end_saturday) { Time.zone.now.end_of_week.change({ hour: 23, min: 59, sec: 59 }) - 1.day }
      let(:rand_saturday) { rand(start_saturday..end_saturday) }

      it 'expect tax value be 7(seven) when is Sunday' do
        calculator = described_class.new
        value = rand(1...999)

        expect(rand_sunday.sunday?).to be_truthy
        expect(calculator.get(value:, time: rand_sunday)).to eq(7)
      end

      it 'expect tax value be 7(seven) when is saturday' do
        calculator = described_class.new
        value = rand(1...999)

        expect(rand_saturday.saturday?).to be_truthy
        expect(calculator.get(value:, time: rand_saturday)).to eq(7)
      end
    end

    context 'when time monday after 6pm and value is less than 1000' do
      it 'expect tax value be 7(seven)' do
        sunday_after_busines_hour = Time.zone.now.beginning_of_week.change({ hour: 18, min: 0, sec: 1 })

        calculator = described_class.new
        value = rand(1...999)

        expect(calculator.get(value:, time: sunday_after_busines_hour)).to eq(7)
      end
    end
  end
end
