# frozen_string_literal: true

module OperationBuilderHelpers
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

  def vital?(label, supplier)
    is_vital_label = VITAL_LABELS.any? { |s| label.include?(s) }
    is_vital_supplier = VITAL_SUPPLIERS.any? { |s| supplier&.include?(s) }

    is_vital_label || is_vital_supplier
  end

  def income?(amount)
    amount.positive?
  end
end
