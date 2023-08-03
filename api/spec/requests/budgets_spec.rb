# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Budgets' do
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }
  let(:expected_attributes) do
    %i[name
       forecastIncome
       forecastVital
       forecastNonEssential
       forecastSaving
       forecastVitalDiff
       forecastNonEssentialDiff
       forecastSavingDiff
       forecastVitalDiffPercentage
       forecastNonEssentialDiffPercentage
       forecastSavingDiffPercentage]
  end

  describe 'GET /budgets' do
    let(:budget) { create(:budget) }

    let(:data) { JSON.parse(response.parsed_body)['data'] }

    before do
      create_list(:line, 4, budget:, line_type: :income)
      create_list(:line, 4, budget:, line_type: :vital)
      create_list(:line, 4, budget:, line_type: :non_essential)
      create(:objective, budget:)
      get budgets_url, headers:
    end

    it { expect(response).to have_http_status(:ok) }

    it { expect(data).to all(have_link(:self)) }

    it { expect(data).to all(have_type('budgets')) }

    it {
      expect(data).to all have_jsonapi_attributes(*expected_attributes).exactly
    }

    it { expect(data).to all have_relationships(:lines, :objective).exactly }
  end

  describe 'GET /budgets/{id}' do
    let(:budget) { create(:budget) }

    before do
      create_list(:line, 4, budget:, line_type: :income)
      create_list(:line, 4, budget:, line_type: :vital)
      create_list(:line, 4, budget:, line_type: :non_essential)
      create(:objective, budget:)
      get budget_url(budget_id), headers:
    end

    context 'when budget does not exists' do
      let(:budget_id) { -1 }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when budget exists' do
      let(:budget_id) { budget.id }
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('budgets') }

      it {
        expect(data).to have_jsonapi_attributes(*expected_attributes).exactly
      }

      it { expect(data).to have_relationships(:lines, :objective).exactly }
    end
  end

  describe 'DELETE /budgets/{id}' do
    it { expect { delete budget_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end

  describe 'PATCH /budgets/{id}' do
    it { expect { patch budget_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end
end
