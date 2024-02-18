# frozen_string_literal: true

class LinkUserOperations < ActiveRecord::Migration[7.0]
  def up
    change_table :operations do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end

    Operation.all.update!(user: User.first)
  end

  def down
    remove_column :operations, :user_id, :bigint
  end
end
