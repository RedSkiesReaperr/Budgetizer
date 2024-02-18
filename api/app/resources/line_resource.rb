# frozen_string_literal: true

class LineResource < JSONAPI::Resource
  attributes :label, :amount, :line_type, :category

  def self.records(options = {})
    context = options[:context]
    context[:current_user].lines
  end
end
