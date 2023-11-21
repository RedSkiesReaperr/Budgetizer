# frozen_string_literal: true

module OperationsCsv
  class Validator
    def validate(content)
      headers = content.size.positive? ? content[0].to_h.keys : []
      missing_headers = mandatory_headers - (mandatory_headers & headers)

      raise CsvFile::Errors::EmptyFileError unless content.size.positive?
      raise CsvFile::Errors::MissingHeaderError, missing_headers unless missing_headers.empty?
    end

    private

    def mandatory_headers
      @mandatory_headers ||= %w[dateOp label amount comment supplierFound]
    end
  end
end
