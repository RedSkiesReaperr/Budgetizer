# frozen_string_literal: true

class CategoryValidator < ActiveModel::Validator
  def validate(record)
    return unless record.category
    return if record.category.user == record.user

    record.errors.add(:category, "should be owned by same user as #{record.class}")
  end
end
