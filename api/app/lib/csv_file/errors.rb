# frozen_string_literal: true

module CsvFile
  module Errors
    class CsvFileError < StandardError
      attr_reader :message
    end

    class MissingHeaderError < CsvFileError
      def initialize(headers)
        super

        @message = "Missing columns: #{headers.join(',')}"
      end
    end

    class EmptyFileError < CsvFileError
      def initialize
        super

        @message = 'CSV is empty'
      end
    end

    class SanitizeError < CsvFileError
      def initialize(value, type)
        super()

        @message = "Invalid value '#{value}' for type #{type}"
      end
    end
  end
end
