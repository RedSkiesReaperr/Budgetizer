# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineImportHelpers do
  describe '#line_type' do
    let(:result) { described_class.line_type(csv_key) }

    context 'when CSV key is REV' do
      let(:csv_key) { 'REV' }

      it { expect(result).to eq(Line.line_types[:income]) }
    end

    context 'when CSV key is VITAL' do
      let(:csv_key) { 'VITAL' }

      it { expect(result).to eq(Line.line_types[:vital]) }
    end

    context 'when CSV key is NO-ESS' do
      let(:csv_key) { 'NO-ESS' }

      it { expect(result).to eq(Line.line_types[:non_essential]) }
    end

    context 'when CSV key is unknown' do
      let(:csv_key) { 'unknown' }

      it { expect { result }.to raise_error("Unknown category key: '#{csv_key}'") }
    end
  end
end
