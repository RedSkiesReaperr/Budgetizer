# frozen_string_literal: true

class LinkLinesToCategories < ActiveRecord::Migration[7.0]
  def change
    remove_column :lines, :category, :int

    change_table :lines do |t|
      t.belongs_to :category, index: true, foreign_key: true
    end
  end
end
