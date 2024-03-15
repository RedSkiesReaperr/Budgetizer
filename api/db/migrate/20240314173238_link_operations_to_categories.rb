# frozen_string_literal: true

class LinkOperationsToCategories < ActiveRecord::Migration[7.0]
  def change
    remove_column :operations, :category, :int

    change_table :operations do |t|
      t.belongs_to :category, index: true, foreign_key: true
    end
  end
end
