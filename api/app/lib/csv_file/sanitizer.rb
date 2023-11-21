# frozen_string_literal: true

module CsvFile
  class Sanitizer
    def coerce(value:, type:)
      case type
      when :string
        value.to_s
      when :float
        value.delete(' ').gsub(',', '.').to_f
      when :date
        coerce_date(value)
      end
    rescue StandardError
      raise CsvFile::Errors::SanitizeError.new(value, type)
    end

    private

    def coerce_date(raw)
      Date.parse(raw)
    rescue StandardError
      Time.zone.today
    end
  end
end
