# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ImportConfigs' do
  let(:user) { create(:user) }
  let(:category) { create(:category, user:) }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'GET /importConfigs' do
    let(:import_configs) { create_list(:import_config, 4, user:) }
    let(:data) { JSON.parse(response.parsed_body)['data'] }

    before do
      import_configs
      call_endpoint('GET', import_configs_url, nil, headers)
    end

    it_behaves_like 'authenticated request', 'GET', '/importConfigs'

    it { expect(response).to have_http_status(:ok) }

    it { expect(data).to all(have_link(:self)) }

    it { expect(data).to all(have_type('importConfigs')) }

    it { expect(data).to all have_jsonapi_attributes(:value, :categoryId).exactly }
  end

  describe 'GET /importConfigs/{id}' do
    let(:import_config) { create(:import_config, user:) }

    before do
      import_config
      call_endpoint('GET', import_config_url(import_config_id), nil, headers)
    end

    context 'when import config does not exists' do
      let(:import_config_id) { -1 }

      it_behaves_like 'authenticated request', 'GET', '/importConfigs/-1'

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when import config exists' do
      let(:import_config_id) { import_config.id }
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('importConfigs') }

      it { expect(data).to have_jsonapi_attributes(:value, :categoryId).exactly }
    end
  end

  describe 'POST /importConfigs' do
    before do
      call_endpoint('POST', import_configs_url, body.to_json, headers)
    end

    context 'when a mandatory field is missing' do
      let(:body) do
        {
          data: {
            type: 'importConfigs',
            attributes: {
              categoryId: category.id
            }
          }
        }
      end

      it_behaves_like 'authenticated request', 'POST', '/importConfigs'

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when all fields are fulfilled' do
      let(:body) do
        {
          data: {
            type: 'importConfigs',
            attributes: {
              value: 'test value'
            }
          }
        }
      end

      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:created) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('importConfigs') }

      it { expect(data).to have_jsonapi_attributes(:value, :categoryId) }
    end
  end

  describe 'DELETE /importConfigs/{id}' do
    let(:import_config) { create(:import_config, user:) }

    before do
      import_config
      call_endpoint('DELETE', import_config_url(import_config.id), nil, headers)
    end

    it_behaves_like 'authenticated request', 'DELETE', '/importConfigs/-1'

    it { expect(response).to have_http_status(:no_content) }

    it 'removes the import config' do
      expect { ImportConfig.find(import_config.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH /importConfigs/{id}' do
    let(:import_config) { create(:import_config, user:) }

    before do
      import_config
      call_endpoint('PATCH', import_config_url(import_config.id), body.to_json, headers)
    end

    context 'when editing only editable fields' do
      let(:body) do
        {
          data: {
            type: 'importConfigs',
            id: import_config.id,
            attributes: {
              value: 'new value',
              categoryId: category.id
            }
          }
        }
      end

      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('importConfigs') }

      it { expect(data).to have_jsonapi_attributes(:value, :categoryId) }
    end
  end
end
