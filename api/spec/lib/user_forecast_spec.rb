# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserForecast do
  subject(:calculator) { described_class.new(user) }

  let(:user) { create(:user) }

  before do
    create(:objective, user:, vital: 61, non_essential: 30, saving: 9)
    create(:line, user:, line_type: :income, amount: 2580.20)
    create(:line, user:, line_type: :income, amount: 604.71)
    create(:line, user:, line_type: :vital, amount: 1300.10)
    create(:line, user:, line_type: :vital, amount: 61.28)
    create(:line, user:, line_type: :non_essential, amount: 780.10)
    create(:line, user:, line_type: :non_essential, amount: 55.57)
  end

  describe '.income' do
    it { expect(calculator.income).to eq(3184.91) }
  end

  describe '.vital' do
    it { expect(calculator.vital).to eq(1361.3799999999999) }
  end

  describe '.non_essential' do
    it { expect(calculator.non_essential).to eq(835.6700000000001) }
  end

  describe '.saving' do
    it { expect(calculator.saving).to eq(987.8599999999997) }
  end

  describe '.vital_diff' do
    it { expect(calculator.vital_diff).to eq(-581.4150999999999) }
  end

  describe '.non_essential_diff' do
    it { expect(calculator.non_essential_diff).to eq(-119.80299999999977) }
  end

  describe '.saving_diff' do
    it { expect(calculator.saving_diff).to eq(701.2180999999997) }
  end

  describe '.vital_diff_percentage' do
    it { expect(calculator.vital_diff_percentage).to eq(-29.926732880888984) }
  end

  describe '.non_essential_diff_percentage' do
    it { expect(calculator.non_essential_diff_percentage).to eq(-12.538606533099292) }
  end

  describe '.saving_diff_percentage' do
    it { expect(calculator.saving_diff_percentage).to eq(244.63210019191183) }
  end
end
