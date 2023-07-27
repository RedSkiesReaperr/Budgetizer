# frozen_string_literal: true

class CreateOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :operations do |t|
      t.datetime :date, null: false
      t.string :label, null: false
      t.float :amount, null: false
      t.string :comment
      t.boolean :pointed, default: false, null: false
      t.integer :op_type, default: 0, null: false
      t.string :identifier, index: { unique: true, name: 'unique_identifier' }
      t.timestamps
    end
  end
end
