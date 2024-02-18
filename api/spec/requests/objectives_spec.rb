# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Objectives' do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'GET /objectives' do
    let(:objectives) { create(:objective, user:) }
    let(:data) { response.parsed_body['data'] }

    before do
      objectives
      call_endpoint('GET', objectives_url, nil, headers)
    end

    it_behaves_like 'authenticated request', 'GET', '/objectives'

    it { expect(response).to have_http_status(:ok) }

    it { expect(data).to all(have_link(:self)) }

    it { expect(data).to all(have_type('objectives')) }

    it { expect(data).to all have_jsonapi_attributes(:vital, :nonEssential, :saving).exactly }
  end

  describe 'GET /objectives/{id}' do
    let(:objective) { create(:objective, user:) }

    before do
      objective
      call_endpoint('GET', objective_url(objective.id), nil, headers)
    end

    it_behaves_like 'authenticated request', 'GET', '/objectives/-1'

    it { expect(response).to have_http_status(:method_not_allowed) }
  end

  describe 'DELETE /objectives/{id}' do
    it { expect { delete objective_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end

  describe 'PATCH /objectives/{id}' do
    it { expect { patch objective_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end
end
