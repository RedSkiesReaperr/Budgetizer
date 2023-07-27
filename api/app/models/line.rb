# frozen_string_literal: true

class Line < ApplicationRecord
  belongs_to :budget

  enum :line_type, %i[income vital non_essential], default: nil
  enum :category, %i[to_categorize home bank shopping food subscriptions auto_transport beauty_care taxes], default: 0

  validates :label, :amount, :line_type, presence: true
end
