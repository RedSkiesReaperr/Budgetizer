# frozen_string_literal: true

class LinkBudgetLines < ActiveRecord::Migration[7.0]
  def change
    change_table :lines do |t|
      t.belongs_to :budget
    end
  end
end
