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

  def import_configs(user)
    @import_configs ||= user.import_configs.where.not(category: nil)
  end

  def guessed_category(label, user)
    import_config = import_configs(user).find { |ic| label.include?(ic.value) }
    import_config&.category
  end
end
