# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'coerce method' do |type, input:, expected_values:|
  let(:result) { described_class.new.coerce(value:, type:) }

  it "coerces values as #{type}" do
    input.each_with_index do |v, i|
      result = described_class.new.coerce(value: v, type:)

      expect(result).to eq(expected_values[i])
    end
  end
end

RSpec.describe CsvFile::Sanitizer do
  describe '.coerce' do
    context 'when coercion is not possible' do
      let(:input) { 89.38 }

      it 'raises SanitizeError' do
        expect { described_class.new.coerce(value: input, type: :float) }.to raise_error(CsvFile::Errors::SanitizeError)
      end
    end

    context 'when type is :string' do
      include_examples 'coerce method',
                       :string,
                       input: ['this is a string', 56.73, 98],
                       expected_values: ['this is a string', '56.73', '98']
    end

    context 'when type is :float' do
      include_examples 'coerce method',
                       :float,
                       input: [' -124,90 ', '56 . 73', '65,03$', 'this is a str'],
                       expected_values: [-124.90, 56.73, 65.03, 0.00]
    end

    context 'when type is :date' do
      include_examples 'coerce method',
                       :date,
                       input: ['16/04/1997', 'not a date', 16_041_997],
                       expected_values: [Date.new(1997, 4, 16), Time.zone.today, Time.zone.today]
    end
  end
end
