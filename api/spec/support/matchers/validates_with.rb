# frozen_string_literal: true

require 'rails_helper'

# This custom matcher checks if a model is validated with a given custom validator class (validator_klass)
RSpec::Matchers.define :validates_with do |validator_klass|
  match do |target|
    validator = target._validate_callbacks.select { |callback| callback.filter.instance_of?(validator_klass) }

    expect(validator.size).to eq(1)
  end
end
