# frozen_string_literal: true

class OperationResource < JSONAPI::Resource
  attributes :date, :label, :amount, :comment, :pointed, :op_type, :category

  filter :start_at,
         verify: ->(values, _context) { Time.zone.parse(values.first) },
         apply: lambda { |records, value, _options|
           records.where('operations.date >= ?', value)
         }

  filter :end_at,
         verify: ->(values, _context) { Time.zone.parse(values.first) },
         apply: lambda { |records, value, _options|
           records.where('operations.date <= ?', value)
         }

  def self.updatable_fields(context)
    super - [:date]
  end
end
