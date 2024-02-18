# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'Associations' do
    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:lines).dependent(:destroy) }
    it { is_expected.to have_one(:objective).dependent(:destroy) }
  end

  describe 'Callbacks' do
    it { is_expected.to callback(:create_default_categories).after(:create) }
  end
end
