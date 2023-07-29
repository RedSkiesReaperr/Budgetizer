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
end
