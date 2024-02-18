# frozen_string_literal: true

class LinkUserObjectives < ActiveRecord::Migration[7.0]
  def up
    change_table :objectives do |t|
      t.belongs_to :user, index: { unique: true }, foreign_key: true
    end

    Objective.all.update!(user: User.first)
  end

  def down
    remove_column :objectives, :user_id, :bigint
  end
end
