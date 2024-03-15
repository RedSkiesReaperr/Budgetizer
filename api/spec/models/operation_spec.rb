# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operation do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category).optional }
  end

  describe 'Validations' do
    describe ':date' do
      it { is_expected.to validate_presence_of(:date) }
    end

    describe ':label' do
      it { is_expected.to validate_presence_of(:label) }
    end

    describe ':amount' do
      it { is_expected.to validate_presence_of(:amount) }
    end

    describe ':op_type' do
      it { is_expected.to validate_presence_of(:op_type) }
    end

    it { is_expected.to validates_with(CategoryValidator) }
  end

  describe 'Scopes' do
    let(:income_operations) { create_list(:operation, 5, amount: 234.45) }
    let(:expense_operations) { create_list(:operation, 6, amount: -56.98) }

    before do
      income_operations
      expense_operations
    end

    describe '#income' do
      it 'returns only income operations' do
        expect(described_class.income).to eq(income_operations)
      end
    end

    describe '#expense' do
      it 'returns only expense operations' do
        expect(described_class.expense).to eq(expense_operations)
      end
    end
  end
end
