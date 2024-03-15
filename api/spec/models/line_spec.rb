# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Line do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category).optional }
  end

  describe 'Validations' do
    describe ':label' do
      it { is_expected.to validate_presence_of(:label) }
    end

    describe ':amount' do
      it { is_expected.to validate_presence_of(:amount) }
    end

    describe ':line_type' do
      it { is_expected.to validate_presence_of(:line_type) }
    end

    it { is_expected.to validates_with(CategoryValidator) }
  end
end
