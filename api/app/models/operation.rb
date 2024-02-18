# frozen_string_literal: true

class Operation < ApplicationRecord
  enum :op_type, %i[unknown income vital non_essential], default: 0
  enum :category, %i[to_categorize home bank shopping food subscriptions auto_transport beauty_care taxes salary],
       default: 0

  validates :date, :label, :amount, :op_type, presence: true

  scope :income, -> { where(amount: 0...) }
  scope :expense, -> { where(amount: ...0) }
end
