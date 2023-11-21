# frozen_string_literal: true

module CsvFile
  class Processor
    def initialize(file_path:, validator:, sanitizer:)
      @file_path = file_path
      @validator = validator
      @sanitizer = sanitizer
    end

    def process
      validator.validate(content)
      sanitizer.sanitize(content)
    end

    private

    attr_reader :file_path, :validator, :sanitizer

    def content
      @content ||= CsvFile::Reader.read(file_path:)
    end
  end
end
