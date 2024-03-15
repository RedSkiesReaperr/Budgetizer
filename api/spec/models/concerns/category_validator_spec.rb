# frozen_string_literal: true

require 'rails_helper'

class CategoryValidatorTester
  attr_accessor :user, :category, :errors

  def initialize(user:, category:)
    @errors = ActiveModel::Errors.new(self)
    @user = user
    @category = category
  end
end

RSpec.describe CategoryValidator do
  let(:validation) { described_class.new.validate(target) }
  let(:target) { CategoryValidatorTester.new(user:, category:) }

  before do
    validation
  end

  context 'when target does not have category' do
    let(:user) { nil }
    let(:category) { nil }

    it { expect(target.errors.size).to eq(0) }
  end

  context 'when target category does not belong to same user' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: create(:user)) }

    it { expect(target.errors.size).to eq(1) }
  end

  context 'when target category belongs to same user' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user:) }

    it { expect(target.errors.size).to eq(0) }
  end
end
