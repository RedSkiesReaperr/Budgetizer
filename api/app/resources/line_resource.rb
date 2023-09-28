# frozen_string_literal: true

class LineResource < JSONAPI::Resource
  has_one :budget

  attributes :label, :amount, :line_type, :category
end
