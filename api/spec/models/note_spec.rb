# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note do
  let(:user) { create(:user) }
  let(:record) { described_class.new(title: 'Title', description: 'description', month: 1, year: 2023, user:) }

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    describe ':title' do
      it { is_expected.to validate_presence_of(:title) }
    end

    describe ':description' do
      it { is_expected.to validate_presence_of(:description) }
    end

    describe ':month' do
      it { is_expected.to validate_presence_of(:month) }
      it { is_expected.to validate_numericality_of(:month) }

      it 'is not valid with month other than integer' do
        record.month = 3.0
        expect(record).not_to be_valid
      end

      it 'is not valid with month less than 1' do
        record.month = 0
        expect(record).not_to be_valid
      end

      it 'is not valid with month greater than 12' do
        record.month = 14
        expect(record).not_to be_valid
      end
    end

    describe ':year' do
      it { is_expected.to validate_presence_of(:year) }
      it { is_expected.to validate_numericality_of(:year) }

      it 'is not valid with year other than integer' do
        record.year = 2022.0
        expect(record).not_to be_valid
      end

      it 'is not valid with year less or equal to 0' do
        record.year = -1
        expect(record).not_to be_valid
      end
    end
  end
end
