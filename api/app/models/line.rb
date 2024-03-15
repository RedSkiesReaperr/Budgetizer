# frozen_string_literal: true

class Line < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :user
  belongs_to :category, optional: true

  enum :line_type, %i[income vital non_essential], default: nil

  validates :label, :amount, :line_type, presence: true
  validates_with CategoryValidator
end
