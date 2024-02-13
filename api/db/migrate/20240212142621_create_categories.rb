# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def up
    create_table :categories do |t|
      t.references :user, foreign_key: true, index: true
      t.string :key, null: false
      t.string :color, null: false
      t.string :icon, null: false
      t.timestamps
      t.index [:key, :user_id], unique: true
    end

    User.all.each(&:create_default_categories)
  end

  def down
    drop_table :categories
  end
end
