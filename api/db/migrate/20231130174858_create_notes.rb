# frozen_string_literal: true

class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :month, null: false
      t.integer :year, null: false

      t.timestamps
    end

    add_reference :notes, :user, index: true, foreign_key: true
  end
end
