# frozen_string_literal: true

class LinkUserLines < ActiveRecord::Migration[7.0]
  def up
    change_table :lines do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end

    Line.all.update!(user: User.first)
  end

  def down
    remove_column :lines, :user_id, :bigint
  end
end
