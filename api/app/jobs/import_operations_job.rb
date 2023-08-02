# frozen_string_literal: true

class ImportOperationsJob < ApplicationJob
  include OperationImportHelpers

  queue_as :default

  def perform(expenses_file: 'vendor/expenses.csv', income_file: 'vendor/incomes.csv')
    operations_to_create = []

    FileReaders::Csv.read(file_path: expenses_file) do |expense|
      operations_to_create << line_hash(expense)
    end

    FileReaders::Csv.read(file_path: income_file) do |income|
      operations_to_create << line_hash(income)
    end

    # TODO: Ignore "virement interne" lines
    Operation.create!(operations_to_create)
  end

  private

  def line_hash(operation)
    {
      date: operation['dateOp'],
      label: operation['label'],
      amount: operation['amount'].delete(' ').gsub(',', '.').to_f,
      comment: operation['comment'],
      op_type: op_type(operation),
      identifier: Base64.encode64(operation.to_a.to_s)
    }
  end
end
