# frozen_string_literal: true

class RemoveOperationsIdentifier < ActiveRecord::Migration[7.0]
  def change
    remove_column :operations, :identifier
  end
end
