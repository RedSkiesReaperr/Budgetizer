# frozen_string_literal: true

class ImportLinesJob < ApplicationJob
  include LineImportHelpers

  queue_as :default

  def perform(budget:, lines_path: 'vendor/budget.csv')
    lines_to_create = []

    FileReaders::Csv.read(file_path: lines_path) do |line|
      lines_to_create << {
        amount: line['amount'].to_f,
        line_type: line_type(line['type']),
        label: line['label'],
        budget:
      }
    end

    Line.create!(lines_to_create)
  end
end
