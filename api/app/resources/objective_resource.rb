# frozen_string_literal: true

class ObjectiveResource < JSONAPI::Resource
  immutable

  has_one :budget

  attributes :vital, :non_essential, :saving
end
