# frozen_string_literal: true

class ImportConfig < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :category, optional: true
  belongs_to :user

  validates :value, presence: true
  validates_with CategoryValidator
end
