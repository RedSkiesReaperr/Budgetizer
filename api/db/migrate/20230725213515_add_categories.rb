# frozen_string_literal: true

class AddCategories < ActiveRecord::Migration[7.0]
  def change
    change_table :lines do |t|
      t.integer :category, default: 0
    end

    change_table :operations do |t|
      t.integer :category, default: 0
    end
  end
end
