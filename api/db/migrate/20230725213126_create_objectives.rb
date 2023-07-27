# frozen_string_literal: true

class CreateObjectives < ActiveRecord::Migration[7.0]
  def change
    create_table :objectives do |t|
      t.integer :vital, null: false
      t.integer :non_essential, null: false
      t.integer :saving, null: false
      t.timestamps
    end
  end
end
