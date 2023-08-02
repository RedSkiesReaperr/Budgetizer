# frozen_string_literal: true

require 'csv'

module FileReaders
  module Csv
    module_function

    def read(file_path:, separator: ';')
      file = File.read(file_path, encoding: 'bom|utf-8')
      csv = CSV.parse(file, headers: true, col_sep: separator)

      csv.each do |line|
        yield(line.to_h)
      end
    end
  end
end
