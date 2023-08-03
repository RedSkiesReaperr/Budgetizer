# frozen_string_literal: true

require 'rails_helper'

describe Budget do
  let(:budget) { create(:budget) }
  let!(:income_lines) { create_list(:line, Faker::Number.between(from: 2, to: 15), budget:, line_type: :income) }
  let!(:vital_lines) { create_list(:line, Faker::Number.between(from: 2, to: 15), budget:, line_type: :vital) }
  let!(:non_essential_lines) do
    create_list(:line, Faker::Number.between(from: 2, to: 15), budget:, line_type: :non_essential)
  end

  describe '.forecast_income' do
    it 'returns the sum of income lines' do
      expect(budget.forecast_income).to eq(income_lines.sum(&:amount))
    end
  end

  describe '.forecast_vital' do
    it 'returns the sum of income lines' do
      expect(budget.forecast_vital).to eq(vital_lines.sum(&:amount))
    end
  end

  describe '.forecast_non_essential' do
    it 'returns the sum of income lines' do
      expect(budget.forecast_non_essential).to eq(non_essential_lines.sum(&:amount))
    end
  end

  describe '.forecast_saving' do
    it 'returns the sum of income lines' do
      expected = income_lines.sum(&:amount) - (vital_lines.sum(&:amount) + non_essential_lines.sum(&:amount))

      expect(budget.forecast_saving).to eq(expected)
    end
  end

  describe 'forecast_vital_diff' do
    it do
      expected = budget.forecast_vital - budget.objective.vital_value

      expect(budget.forecast_vital_diff).to eq(expected)
    end
  end

  describe 'forecast_non_essential_diff' do
    it do
      expected = budget.forecast_non_essential - budget.objective.non_essential_value

      expect(budget.forecast_non_essential_diff).to eq(expected)
    end
  end

  describe 'forecast_saving_diff' do
    it do
      expected = budget.forecast_vital - budget.objective.saving_value

      expect(budget.forecast_saving_diff).to eq(expected)
    end
  end

  describe 'forecast_vital_diff_percentage' do
    it do
      expected = ((budget.forecast_vital - budget.objective.vital_value) / budget.objective.vital_value) * 100

      expect(budget.forecast_vital_diff_percentage).to eq(expected)
    end
  end

  describe 'forecast_non_essential_diff_percentage' do
    it do
      expected = budget.forecast_non_essential - budget.objective.non_essential_value
      expected /= budget.objective.non_essential_value
      expected *= 100

      expect(budget.forecast_non_essential_diff_percentage).to eq(expected)
    end
  end

  describe 'forecast_saving_diff_percentage' do
    it do
      expected = ((budget.forecast_saving - budget.objective.saving_value) / budget.objective.saving_value) * 100

      expect(budget.forecast_saving_diff_percentage).to eq(expected)
    end
  end
end
