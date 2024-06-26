# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user

  has_many :lines, dependent: :nullify
  has_many :operations, dependent: :nullify
  has_many :import_configs, dependent: :nullify

  validates :key, :color, :icon, presence: true
  validates :key, format: { with: /\A[a-z][_a-z]+[a-z]\z/ }
  validates :color, format: { with: /\A#(\d|[a-zA-Z]){6}\z/ }
  validates :icon, format: { with: /\Amdi-[-|a-z0-9]+[a-z0-9]\z/ }
  validates :key, uniqueness: { scope: :user_id }
end
