# frozen_string_literal: true

class CategoryResource < JSONAPI::Resource
  attributes :key, :color, :icon

  def self.records(options = {})
    context = options[:context]
    context[:current_user].categories
  end

  def save
    @model.user ||= context[:current_user]
    super
  end
end
