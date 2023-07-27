# frozen_string_literal: true

class RenameLineCategoryToLineType < ActiveRecord::Migration[7.0]
  def self.up
    rename_column :lines, :category, :line_type
  end

  def self.down
    rename_column :lines, :line_type, :category
  end
end
