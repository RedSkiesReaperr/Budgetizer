# frozen_string_literal: true

class CreateImportConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :import_configs do |t|
      t.string :value, null: false
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
