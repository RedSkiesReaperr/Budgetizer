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

  describe 'POST /categories' do
    before do
      call_endpoint('POST', categories_url, body.to_json, headers)
    end

    context 'when a mandatory field is missing' do
      let(:body) do
        {
          data: {
            type: 'categories',
            attributes: {
              key: 'test_key',
              color: '#azerty'
            }
          }
        }
      end

      it_behaves_like 'authenticated request', 'POST', '/categories'

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when all fields are fulfilled' do
      let(:body) do
        {
          data: {
            type: 'categories',
            attributes: {
              key: 'test_key',
              color: '#azerty',
              icon: 'mdi-test'
            }
          }
        }
      end

      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:created) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('categories') }

      it { expect(data).to have_jsonapi_attributes(:key, :color, :icon) }
    end
  end

  describe 'DELETE /categories/{id}' do
    let(:category) { create(:category, user:) }

    before do
      category
      call_endpoint('DELETE', category_url(category.id), nil, headers)
    end

    it_behaves_like 'authenticated request', 'DELETE', '/categories/-1'

    it { expect(response).to have_http_status(:no_content) }

    it 'removes the category' do
      expect { Category.find(category.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH /categories/{id}' do
    let(:category) { create(:category) }

    before do
      category
      call_endpoint('PATCH', category_url(category.id), nil, headers)
    end

    it_behaves_like 'authenticated request', 'PATCH', '/categories/-1'

    it { expect(response).to have_http_status(:method_not_allowed) }
  end

  describe 'PUT /categories/{id}' do
    let(:category) { create(:category) }

    before do
      category
      call_endpoint('PUT', category_url(category.id), nil, headers)
    end

    it_behaves_like 'authenticated request', 'PUT', '/categories/-1'

    it { expect(response).to have_http_status(:method_not_allowed) }
  end
end
