# frozen_string_literal: true

class OperationsImporter
  def initialize(user:)
    @user = user
  end

  def import(file_path:)
    file_processor = CsvFile::Processor.new(file_path:,
                                            validator: OperationsCsv::Validator.new,
                                            sanitizer: OperationsCsv::Sanitizer.new)
    director = OperationBuildingDirector.new(@user)

    operations = file_processor.process.map { |line| director.build_operation(line) }

    Operation.create!(operations)
  end
end
