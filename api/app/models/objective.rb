# frozen_string_literal: true

class Objective < ApplicationRecord
  has_one :budget, dependent: nil

  validates :vital, :non_essential, :saving, presence: true, numericality: { greater_than: 0, less_than: 100 }

  validate :sum_is_one_hundred

  def vital_value
    vital * budget.forecast_income / 100
  end

  def non_essential_value
    non_essential * budget.forecast_income / 100
  end

  def saving_value
    saving * budget.forecast_income / 100
  end

  private

  def sum_is_one_hundred
    sum = vital + non_essential + saving

    return if sum == 100

    errors.add(:attributes, "Sum of vital, non_essential & saving should equal 100. Got: '#{sum}'")
  end
end
