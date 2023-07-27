# frozen_string_literal: true

class CreateBudgets < ActiveRecord::Migration[7.0]
  def change
    create_table :budgets do |t|
      t.belongs_to :objective
      t.string :name, null: false
      t.timestamps
    end
  end
end
