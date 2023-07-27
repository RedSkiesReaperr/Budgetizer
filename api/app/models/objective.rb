# frozen_string_literal: true

class Objective < ApplicationRecord
  has_one :budget

  validates :vital, :non_essential, :saving, presence: true, numericality: { greater_than: 0, less_than: 100 }

  def vital_value(base)
    vital * base / 100
  end

  def non_essential_value(base)
    non_essential * base / 100
  end

  def saving_value(base)
    saving * base / 100
  end
end
