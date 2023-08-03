# frozen_string_literal: true

require 'rails_helper'

describe Objective do
  let(:objective) { create(:objective) }

  before do
    allow(objective.budget).to receive(:forecast_income).and_return(3201.87)
  end

  describe '.vital_value' do
    it { expect(objective.vital_value).to eq(1600.935) }
  end

  describe '.non_essential_value' do
    it { expect(objective.non_essential_value).to eq(960.5609999999999) }
  end

  describe '.saving_value' do
    it { expect(objective.saving_value).to eq(640.3739999999999) }
  end

  describe 'sum_is_one_hundred validation' do
    context 'when sum of objective fields are not equal to 100' do
      let(:vital) { 99 }
      let(:non_essential) { 10 }
      let(:saving) { 10 }

      it {
        expect do
          described_class.create!(vital:, non_essential:, saving:)
        end.to raise_error(ActiveRecord::RecordInvalid)
      }
    end

    context 'when sum of objective fields are equal to 100' do
      let(:vital) { 70 }
      let(:non_essential) { 15 }
      let(:saving) { 15 }

      it {
        expect do
          described_class.create!(vital:, non_essential:, saving:)
        end.not_to raise_error(ActiveRecord::RecordInvalid)
      }
    end
  end
end
