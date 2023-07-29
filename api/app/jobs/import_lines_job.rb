# frozen_string_literal: true

class ImportLinesJob < ApplicationJob
  include LineImportHelpers

  queue_as :default

  def perform(budget:)
    lines_to_create = []

    FileReaders::Csv.read(file_path: 'budget.csv') do |line|
      lines_to_create << {
        amount: line['amount'].to_f,
        category: category(line['category']),
        label: line['label'],
        budget:
      }
    end

    Line.create!(lines_to_create)
  end
end
