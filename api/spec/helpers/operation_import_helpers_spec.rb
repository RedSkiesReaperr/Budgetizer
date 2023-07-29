# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationImportHelpers do
  describe '#op_type' do
    let(:result) { described_class.op_type(operation) }

    context 'when operation is vital' do
      let(:operation) { { 'label' => 'HelloFresh', 'supplierFound' => 'virement bnp' } }

      it { expect(result).to eq('vital') }
    end

    context 'when operation is income' do
      let(:operation) { { 'label' => 'NonVitalLabel', 'supplierFound' => 'NonVitalSupplier', 'amount' => '1.99' } }

      it { expect(result).to eq('income') }
    end

    context 'when operation is not vital or income' do
      let(:operation) { { 'label' => 'NonVitalLabel', 'supplierFound' => 'NonVitalSupplier', 'amount' => '-1.99' } }

      it { expect(result).to eq('unknown') }
    end
  end

  describe '#vital?' do
    let(:result) { described_class.vital?({ 'label' => label, 'supplierFound' => supplier }) }

    context 'when operation has a non-vital label & non-vital supplier' do
      let(:label) { 'NonVitalLabel' }
      let(:supplier) { 'NonVitalSupplier' }

      it { expect(result).to be_falsey }
    end

    context 'when operation has a non-vital label & vital supplier' do
      let(:label) { 'NonVitalLabel' }
      let(:supplier) { 'virement bnp' }

      it { expect(result).to be_truthy }
    end

    context 'when operation has a vital label & non-vital supplier' do
      let(:label) { 'HelloFresh' }
      let(:supplier) { 'NonVitalSupplier' }

      it { expect(result).to be_truthy }
    end
  end

  describe '#income?' do
    let(:result) { described_class.income?(row) }

    context 'when operation has positive amount' do
      let(:row) { { 'amount' => '78,54' } }

      it { expect(result).to be_truthy }
    end

    context 'when operation has negative amount' do
      let(:row) { { 'amount' => '-78,54' } }

      it { expect(result).to be_falsey }
    end

    context 'when operation has neutral amount' do
      let(:row) { { 'amount' => '0,00' } }

      it { expect(result).to be_falsey }
    end
  end
end
