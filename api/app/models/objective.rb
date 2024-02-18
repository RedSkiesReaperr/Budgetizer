# frozen_string_literal: true

class Objective < ApplicationRecord
  belongs_to :user

  validates :vital, :non_essential, :saving, presence: true, numericality: { greater_than: 0, less_than: 100 }

  validate :sum_is_one_hundred

  private

  def sum_is_one_hundred
    sum = vital.to_i + non_essential.to_i + saving.to_i

    return if sum == 100

    errors.add(:attributes, "Sum of vital, non_essential & saving should equal 100. Got: '#{sum}'")
  end
end
