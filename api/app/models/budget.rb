# frozen_string_literal: true

class Budget < ApplicationRecord
  belongs_to :objective

  has_many :lines, dependent: :destroy

  validates :name, presence: true

  # FORECAST FUNCTIONS
  def forecast_income
    lines.income.sum(&:amount)
  end

  def forecast_vital
    lines.vital.sum(&:amount)
  end

  def forecast_non_essential
    lines.non_essential.sum(&:amount)
  end

  def forecast_saving
    forecast_income - (forecast_vital + forecast_non_essential)
  end

  def forecast_vital_diff
    forecast_vital - objective.vital_value
  end

  def forecast_non_essential_diff
    forecast_non_essential - objective.non_essential_value
  end

  def forecast_saving_diff
    forecast_vital - objective.saving_value
  end

  def forecast_vital_diff_percentage
    ((forecast_vital - objective.vital_value) / objective.vital_value) * 100
  end

  def forecast_non_essential_diff_percentage
    ((forecast_non_essential - objective.non_essential_value) / objective.non_essential_value) * 100
  end

  def forecast_saving_diff_percentage
    ((forecast_saving - objective.saving_value) / objective.saving_value) * 100
  end
end
