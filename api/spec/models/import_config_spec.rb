# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportConfig do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category).optional }
  end

  describe 'Validations' do
    describe ':value' do
      it { is_expected.to validate_presence_of(:value) }
    end

    it { is_expected.to validates_with(CategoryValidator) }
  end
end
