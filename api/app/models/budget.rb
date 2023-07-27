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
end
