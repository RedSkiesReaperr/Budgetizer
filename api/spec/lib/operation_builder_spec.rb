# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'builder method' do |field:, test_value:, expected:|
  before do
    builder.public_send("build_#{field}", test_value)
  end

  it { expect(builder.result[field]).to eq(expected) }
end

RSpec.describe OperationBuilder do
  let(:builder) { described_class.new }

  describe '.result' do
    it 'returns up to date operation struct' do
      expect(builder.result).to be_a Hash
    end
  end

  describe '.build_date' do
    it_behaves_like 'builder method', field: :date, test_value: Time.zone.today, expected: Time.zone.today
  end

  describe '.build_label' do
    it_behaves_like 'builder method', field: :label, test_value: 'This is a label', expected: 'This is a label'
  end

  describe '.build_amount' do
    it_behaves_like 'builder method', field: :amount, test_value: -451.76, expected: -451.76
  end

  describe '.build_comment' do
    it_behaves_like 'builder method', field: :comment, test_value: 'This is a comment', expected: 'This is a comment'
  end

  describe '.build_pointed' do
    it_behaves_like 'builder method', field: :pointed, test_value: true, expected: true
  end

  describe '.build_op_type' do
    let(:label) { 'label' }
    let(:supplier) { 'uber' }
    let(:amount) { -12.22 }

    context 'when operation is unkown' do
      before do
        allow(builder).to receive(:vital?).and_return(false)
        allow(builder).to receive(:income?).and_return(false)
        builder.build_op_type(label, supplier, amount)
      end

      it { expect(builder.result[:op_type]).to eq(Operation.op_types[:unknown]) }
    end

    context 'when operation is vital' do
      before do
        allow(builder).to receive(:vital?).and_return(true)
        allow(builder).to receive(:income?).and_return(false)
        builder.build_op_type(label, supplier, amount)
      end

      it { expect(builder.result[:op_type]).to eq(Operation.op_types[:vital]) }
    end

    context 'when operation is income' do
      before do
        allow(builder).to receive(:vital?).and_return(false)
        allow(builder).to receive(:income?).and_return(true)
        builder.build_op_type(label, supplier, amount)
      end

      it { expect(builder.result[:op_type]).to eq(Operation.op_types[:income]) }
    end
  end

  describe '.build_category' do
    it_behaves_like 'builder method', field: :category, test_value: :shopping, expected: :shopping
  end
end
