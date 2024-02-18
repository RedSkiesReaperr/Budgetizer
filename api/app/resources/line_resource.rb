# frozen_string_literal: true

class LineResource < JSONAPI::Resource
  attributes :label, :amount, :line_type, :category
end
