# frozen_string_literal: true

class CreateLines < ActiveRecord::Migration[7.0]
  def change
    create_table :lines do |t|
      t.string :label, null: false
      t.float :amount, null: false
      t.integer :category, default: 0
      t.timestamps
    end
  end
end
