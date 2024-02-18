# frozen_string_literal: true

class OperationsController < ApplicationController
  def create
    processor = CsvFile::Processor.new(file_path: create_params.path,
                                       validator: OperationsCsv::Validator.new,
                                       sanitizer: OperationsCsv::Sanitizer.new)

    director = OperationBuildingDirector.new(current_user)
    operations = processor.process.map { |line| director.build_operation(line) }

    Operation.create!(operations)

    render status: :created, json: { success: true }
  rescue CsvFile::Errors::CsvFileError => e
    render status: :unprocessable_entity, json: { success: false, errors: [e.message] }
  end

  def destroy
    render status: :method_not_allowed
  end

  private

  def create_params
    params.require(:file)
  end
end
