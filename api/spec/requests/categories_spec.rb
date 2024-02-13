# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories' do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'GET /categories' do
    let(:categories) { create_list(:category, 4, user:) }
    let(:data) { JSON.parse(response.parsed_body)['data'] }

    before do
      categories
      call_endpoint('GET', categories_url, nil, headers)
    end

    it_behaves_like 'authenticated request', 'GET', '/categories'

    it { expect(response).to have_http_status(:ok) }

    it { expect(data).to all(have_link(:self)) }

    it { expect(data).to all(have_type('categories')) }

    it { expect(data).to all have_jsonapi_attributes(:key, :color, :icon).exactly }
  end

  describe 'GET /categories/{id}' do
    let(:category) { create(:category, user:) }

    before do
      category
      call_endpoint('GET', category_url(category_id), nil, headers)
    end

    context 'when category does not exists' do
      let(:category_id) { -1 }

      it_behaves_like 'authenticated request', 'GET', '/categories/-1'

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when category exists' do
      let(:category_id) { category.id }
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('categories') }

      it { expect(data).to have_jsonapi_attributes(:key, :color, :icon).exactly }
    end
  end

  describe 'DELETE /categories/{id}' do
    it { expect { delete category_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end

  describe 'PATCH /categories/{id}' do
    it { expect { patch category_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end
end
