# frozen_string_literal: true

class OperationResource < JSONAPI::Resource
  attributes :date, :label, :amount, :comment, :pointed, :op_type, :category

  def self.updatable_fields(context)
    super - [:date]
  end
end
