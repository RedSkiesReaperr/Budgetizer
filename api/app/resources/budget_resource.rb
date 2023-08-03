# frozen_string_literal: true

class BudgetResource < JSONAPI::Resource
  immutable

  has_many :lines
  has_one :objective

  attributes :name,
             :forecast_income,
             :forecast_vital,
             :forecast_non_essential,
             :forecast_saving,
             :forecast_vital_diff,
             :forecast_non_essential_diff,
             :forecast_saving_diff,
             :forecast_vital_diff_percentage,
             :forecast_non_essential_diff_percentage,
             :forecast_saving_diff_percentage
end
