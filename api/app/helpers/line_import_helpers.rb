# frozen_string_literal: true

module LineImportHelpers
  module_function

  def line_type(csv_key)
    case csv_key
    when 'REV'
      Line.line_types[:income]
    when 'VITAL'
      Line.line_types[:vital]
    when 'NO-ESS'
      Line.line_types[:non_essential]
    else
      raise "Unknown category key: '#{csv_key}'"
    end
  end
end
