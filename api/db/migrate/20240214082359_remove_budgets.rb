# frozen_string_literal: true

class RemoveBudgets < ActiveRecord::Migration[7.0]
  def change
    drop_table :budgets, reversible: true
    remove_column :lines, :budget_id, :bigint
  end
end
