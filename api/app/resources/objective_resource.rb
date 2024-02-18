# frozen_string_literal: true

class ObjectiveResource < JSONAPI::Resource
  immutable

  attributes :vital, :non_essential, :saving
end
