# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Budgets' do
  let(:user) { create(:user) }
  let(:budget) { create(:budget) }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }
  let(:response_data) { JSON.parse(response.parsed_body)['data'] }
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
    before do
      create_list(:line, 4, budget:, line_type: :income)
      create_list(:line, 4, budget:, line_type: :vital)
      create_list(:line, 4, budget:, line_type: :non_essential)
      create(:objective, budget:)
      call_endpoint('GET', budgets_url, nil, headers)
    end

    it_behaves_like 'authenticated request', 'GET', '/budgets'

    it { expect(response).to have_http_status(:ok) }

    it { expect(response_data).to all(have_link(:self)) }

    it { expect(response_data).to all(have_type('budgets')) }

    it {
      expect(response_data).to all have_jsonapi_attributes(*expected_attributes).exactly
    }

    it { expect(response_data).to all have_relationships(:lines, :objective).exactly }
  end

  describe 'GET /budgets/{id}' do
    before do
      create_list(:line, 4, budget:, line_type: :income)
      create_list(:line, 4, budget:, line_type: :vital)
      create_list(:line, 4, budget:, line_type: :non_essential)
      create(:objective, budget:)
      call_endpoint('GET', budget_url(budget_id), nil, headers)
    end

    context 'when budget does not exists' do
      let(:budget_id) { -1 }

      it_behaves_like 'authenticated request', 'GET', '/budgets/-1'

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when budget exists' do
      let(:budget_id) { budget.id }

      it { expect(response).to have_http_status(:ok) }

      it { expect(response_data).to have_link(:self) }

      it { expect(response_data).to have_type('budgets') }

      it { expect(response_data).to have_jsonapi_attributes(*expected_attributes).exactly }

      it { expect(response_data).to have_relationships(:lines, :objective).exactly }
    end
  end

  describe 'DELETE /budgets/{id}' do
    it { expect { delete budget_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end

  describe 'PATCH /budgets/{id}' do
    it { expect { patch budget_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end
end
