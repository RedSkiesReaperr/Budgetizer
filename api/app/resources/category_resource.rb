# frozen_string_literal: true

class CategoryResource < JSONAPI::Resource
  attributes :key, :color, :icon

  def self.records(options = {})
    context = options[:context]
    context[:current_user].categories
  end
end
