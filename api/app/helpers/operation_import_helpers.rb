# frozen_string_literal: true

module OperationImportHelpers
  VITAL_SUPPLIERS = ['virement bnp'].freeze
  VITAL_LABELS = [
    'AFEDIM Gestion',
    'BOUYGUES TELECOM',
    'FREE MOBILE',
    'E.LECLERC WEB',
    'HelloFresh',
    'HELLOFRESH',
    'Vattenfall'
  ].freeze

  module_function

  def op_type(row)
    return 'vital' if vital?(row)
    return 'income' if income?(row)

    'unknown'
  end

  def vital?(row)
    label = row['label']
    supplier_found = row['supplierFound']
    is_vital_label = VITAL_LABELS.any? { |s| label.include?(s) }
    is_vital_supplier = VITAL_SUPPLIERS.any? { |s| supplier_found&.include?(s) }

    is_vital_label || is_vital_supplier
  end

  def income?(row)
    amount = row['amount'].gsub(',', '.').to_f

    amount.positive?
  end
end
