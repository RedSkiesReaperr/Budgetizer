# frozen_string_literal: true

module OperationsCsv
  class Sanitizer < CsvFile::Sanitizer
    def sanitize(raw_content)
      raw_content.map do |line|
        { date_op: coerce(value: line['dateOp'], type: :date),
          label: coerce(value: line['label'], type: :string),
          amount: coerce(value: line['amount'], type: :float),
          comment: coerce(value: line['comment'], type: :string),
          supplier_found: coerce(value: line['supplierFound'], type: :string) }
      end
    end
  end
end
