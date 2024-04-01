# frozen_string_literal: true

class ImportConfigResource < JSONAPI::Resource
  attributes :value, :category_id

  def self.records(options = {})
    context = options[:context]
    context[:current_user].import_configs
  end

  def save
    @model.user ||= context[:current_user]
    super
  end
end
