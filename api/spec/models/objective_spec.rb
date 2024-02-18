# frozen_string_literal: true

require 'rails_helper'

describe Objective do
  subject { described_class.create!(vital: 50, non_essential: 30, saving: 20, user:) }

  let(:user) { create(:user) }

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    describe ':vital' do
      it { is_expected.to validate_presence_of(:vital) }
      it { is_expected.to validate_numericality_of(:vital) }
    end

    describe ':non_essential' do
      it { is_expected.to validate_presence_of(:non_essential) }
      it { is_expected.to validate_numericality_of(:non_essential) }
    end

    describe ':saving' do
      it { is_expected.to validate_presence_of(:saving) }
      it { is_expected.to validate_numericality_of(:saving) }
    end

    context 'when sum of fields are not equal to 100' do
      let(:vital) { 99 }
      let(:non_essential) { 10 }
      let(:saving) { 10 }

      it {
        expect do
          described_class.create!(vital:, non_essential:, saving:, user:)
        end.to raise_error(ActiveRecord::RecordInvalid)
      }
    end

    context 'when sum of fields are equal to 100' do
      let(:vital) { 70 }
      let(:non_essential) { 15 }
      let(:saving) { 15 }

      it {
        expect do
          described_class.create!(vital:, non_essential:, saving:, user:)
        end.not_to raise_error(ActiveRecord::RecordInvalid)
      }
    end
  end
end
