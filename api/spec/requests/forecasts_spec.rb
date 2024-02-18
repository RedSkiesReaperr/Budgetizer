# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Forecasts' do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }
  let(:response_data) { response.parsed_body['data'] }
  let(:expected_attributes) do
    %i[income
       vital
       nonEssential
       saving
       vitalDiff
       nonEssentialDiff
       savingDiff
       vitalDiffPercentage
       nonEssentialDiffPercentage
       savingDiffPercentage]
  end

  describe 'GET /forecasts' do
    before do
      create_list(:line, 4, user:, line_type: :income)
      create_list(:line, 4, user:, line_type: :vital)
      create_list(:line, 4, user:, line_type: :non_essential)
      create(:objective, user:)
      call_endpoint('GET', forecasts_url, nil, headers)
    end

    it_behaves_like 'authenticated request', 'GET', '/forecasts'

    it { expect(response).to have_http_status(:ok) }

    it { expect(response_data).to have_type('forecasts') }

    it {
      expect(response_data).to have_jsonapi_attributes(*expected_attributes).exactly
    }
  end
end
