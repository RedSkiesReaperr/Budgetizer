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

  describe '#import_configs' do
    let(:user) { create(:user) }
    let(:valid_configs) { create_list(:import_config, 4, user:) }
    let(:invalid_configs) { create_list(:import_config, 2, user:, category: nil) }
    let(:result) { import_configs(user) }

    before do
      valid_configs
      invalid_configs
    end

    it 'returns only valid configs' do
      expect(result).to eq(valid_configs)
    end
  end

  describe '#guessed_category' do
    let(:user) { create(:user) }
    let(:label) { 'my label!' }
    let(:category) { create(:category, user:) }
    let(:result) { guessed_category(label, user) }

    context 'when user does not have any ImportConfig' do
      let(:label) { 'any_label' }

      it { expect(result).to be_nil }
    end

    context 'when no ImportConfig match with label' do
      let(:import_config) { create(:import_config, user:, category:, value: 'WRONG') }

      before do
        import_config
      end

      it { expect(result).to be_nil }
    end

    context 'when an ImportConfig match with label' do
      let(:import_config) { create(:import_config, user:, category:, value: 'label!') }

      before do
        import_config
      end

      it { expect(result).to eq(category) }
    end
  end
end
