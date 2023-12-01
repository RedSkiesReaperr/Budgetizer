# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :user

  validates :title, :description, :month, :year, presence: true
  validates :month, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :year, numericality: { only_integer: true, greater_than: 0 }
end
