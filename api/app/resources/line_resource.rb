# frozen_string_literal: true

class LineResource < JSONAPI::Resource
  immutable

  has_one :budget

  attributes :label, :amount, :line_type, :category
end
