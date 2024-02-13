# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  subject(:record) { build(:category) }

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    describe ':key' do
      it { is_expected.to validate_presence_of(:key) }

      it {
        expect(record).to validate_uniqueness_of(:key)
          .scoped_to(:user_id)
          .with_message("Category '#{record.key}' already exists for this user")
      }

      it_behaves_like 'a format validated model column' do
        let(:column) { :key }
        let(:invalid_values) { %w[home-key home_ _home Home] }
        let(:valid_values) { %w[home home_key] }
      end
    end

    describe ':color' do
      it { is_expected.to validate_presence_of(:color) }

      it_behaves_like 'a format validated model column' do
        let(:column) { :color }
        let(:invalid_values) { %w[2980b9 22980b9 #2980b_ #2980b9_] }
        let(:valid_values) { %w[#2980b9] }
      end
    end

    describe ':icon' do
      it { is_expected.to validate_presence_of(:icon) }

      it_behaves_like 'a format validated model column' do
        let(:column) { :icon }
        let(:invalid_values) { %w[mdiicon mdi- mdi-icon-] }
        let(:valid_values) { %w[mdi-icon mdi-icon-100] }
      end
    end
  end
end
