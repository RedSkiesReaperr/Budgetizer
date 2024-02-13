# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a format validated model column' do
  context 'with invalid values' do
    it 'validation fails' do
      invalid_values.each do |name|
        expect(subject).not_to allow_value(name).for(column)
      end
    end
  end

  context 'with valid values' do
    it 'validation succeed' do
      valid_values.each do |name|
        expect(subject).to allow_value(name).for(column)
      end
    end
  end
end
