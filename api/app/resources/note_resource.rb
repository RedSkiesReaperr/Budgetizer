# frozen_string_literal: true

class NoteResource < JSONAPI::Resource
  attributes :title, :description, :month, :year

  filter :month, default: Time.zone.today.month
  filter :year, default: Time.zone.today.year

  before_save do
    @model.user = context[:current_user] if @model.new_record?
  end

  def self.records(options = {})
    context = options[:context]
    context[:current_user].notes
  end

  def self.updatable_fields(context)
    super - %i[month year]
  end
end
