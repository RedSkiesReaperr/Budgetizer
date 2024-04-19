# frozen_string_literal: true

class OperationsController < ApplicationController
  def create
    OperationsImporter.new(user: current_user).import(file_path: create_params.path)

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
