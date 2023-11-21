# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationBuilderHelpers do
  include described_class

  describe '#vital?' do
    let(:result) { vital?(label, supplier) }

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
    let(:result) { income?(amount) }

    context 'when operation has positive amount' do
      let(:amount) { 78.54 }

      it { expect(result).to be_truthy }
    end

    context 'when operation has negative amount' do
      let(:amount) { -78.54 }

      it { expect(result).to be_falsey }
    end

    context 'when operation has neutral amount' do
      let(:amount) { 0.00 }

      it { expect(result).to be_falsey }
    end
  end
end
