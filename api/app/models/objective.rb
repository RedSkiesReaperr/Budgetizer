# frozen_string_literal: true

class Objective < ApplicationRecord
  has_one :budget, dependent: nil

  validates :vital, :non_essential, :saving, presence: true, numericality: { greater_than: 0, less_than: 100 }

  def vital_value
    vital * budget.forecast_income / 100
  end

  def non_essential_value
    non_essential * budget.forecast_income / 100
  end

  def saving_value
    saving * budget.forecast_income / 100
  end
end
