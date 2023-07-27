# frozen_string_literal: true

require 'rails_helper'

describe Objective do
  let(:objective) { create(:objective) }
  let(:base) { 3201.87 }

  describe '.vital_value' do
    it { expect(objective.vital_value(base)).to eq(1600.935) }
  end

  describe '.non_essential_value' do
    it { expect(objective.non_essential_value(base)).to eq(960.5609999999999) }
  end

  describe '.saving_value' do
    it { expect(objective.saving_value(base)).to eq(640.3739999999999) }
  end
end
