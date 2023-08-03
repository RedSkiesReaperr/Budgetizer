# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Objectives' do
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'GET /objectives' do
    let(:objectives) { create_list(:objective, 4) }
    let(:data) { JSON.parse(response.parsed_body)['data'] }

    before do
      objectives
      get objectives_url, headers:
    end

    it { expect(response).to have_http_status(:ok) }

    it { expect(data).to all(have_link(:self)) }

    it { expect(data).to all(have_type('objectives')) }

    it { expect(data).to all have_jsonapi_attributes(:vital, :nonEssential, :saving).exactly }

    it { expect(data).to all have_relationships(:budget).exactly }
  end

  describe 'GET /objectives/{id}' do
    let(:objective) { create(:objective) }

    before do
      objective
      get objective_url(objective_id), headers:
    end

    context 'when objective does not exists' do
      let(:objective_id) { -1 }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when objective exists' do
      let(:objective_id) { objective.id }
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('objectives') }

      it { expect(data).to have_jsonapi_attributes(:vital, :nonEssential, :saving).exactly }

      it { expect(data).to have_relationships(:budget).exactly }
    end
  end

  describe 'DELETE /objectives/{id}' do
    it { expect { delete objective_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end

  describe 'PATCH /objectives/{id}' do
    it { expect { patch objective_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end
end
