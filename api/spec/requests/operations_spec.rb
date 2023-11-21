# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Operations' do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'POST /operations' do
    let(:body) do
      { file: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/attachments/operations.csv'),
                                           'text/csv') }
    end
    let(:data) do
      [
        { date: Time.zone.today, label: 'today label', amount: -23.1, comment: '', pointed: false, op_type: :vital,
          category: :to_categorize }
      ]
    end

    before do
      call_endpoint('POST', operations_url, body, headers)
    end

    it_behaves_like 'authenticated request', 'POST', '/operations'

    context 'when no operations csv is sent' do
      let(:body) { nil }

      it { expect(response).to have_http_status(:bad_request) }

      it { expect(response.parsed_body).to have_key('success') }

      it { expect(response.parsed_body).to have_key('errors') }
    end

    context 'when import fails' do
      let(:body) do
        { file: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/attachments/unprocessable_operations.csv'),
                                             'text/csv') }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(Operation.count).to eq(0) }
    end

    context 'when import succeed' do
      let(:body) do
        { file: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/attachments/operations.csv'),
                                             'text/csv') }
      end

      it { expect(response).to have_http_status(:created) }

      it { expect(Operation.count).to eq(3) }
    end
  end

  describe 'GET /operations' do
    let(:operations) do
      [
        create(:operation, date: Time.zone.yesterday),
        create(:operation, date: Time.zone.today),
        create(:operation, date: Time.zone.tomorrow),
        create(:operation, date: Time.zone.today + 2)
      ]
    end

    let(:data) { JSON.parse(response.parsed_body)['data'] }

    before do
      operations
      call_endpoint('GET', operations_url(filters), nil, headers)
    end

    context 'without filters' do
      let(:filters) { {} }

      it_behaves_like 'authenticated request', 'GET', '/operations'

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to all(have_link(:self)) }

      it { expect(data).to all(have_type('operations')) }

      it { expect(data).to all have_jsonapi_attributes(:date, :label, :amount, :comment, :pointed, :opType, :category) }
    end

    context 'with start_at filter' do
      let(:filters) { { filter: { start_at: operations.second.date } } }

      it { expect(response).to have_http_status(:ok) }

      it 'returns only newer operations' do
        expect(data.map { |i| i['id'].to_i }).to eq([operations.second.id, operations.third.id, operations.fourth.id])
      end
    end

    context 'with end_at filter' do
      let(:filters) { { filter: { end_at: operations.third.date } } }

      it { expect(response).to have_http_status(:ok) }

      it 'returns only older operations' do
        expect(data.map { |i| i['id'].to_i }).to eq([operations.first.id, operations.second.id, operations.third.id])
      end
    end
  end

  describe 'GET /operations/{id}' do
    let(:operation) { create(:operation) }

    before do
      operation
      call_endpoint('GET', operation_url(operation_id), nil, headers)
    end

    context 'when operation does not exists' do
      let(:operation_id) { -1 }

      it_behaves_like 'authenticated request', 'GET', '/operations/-1'

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when operation exists' do
      let(:operation_id) { operation.id }
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('operations') }

      it { expect(data).to have_jsonapi_attributes(:date, :label, :amount, :comment, :pointed, :opType, :category) }
    end
  end

  describe 'PATCH /operations/{id}' do
    let(:operation) { create(:operation) }

    before do
      operation
      call_endpoint('PATCH', operation_url(operation.id), body.to_json, headers)
    end

    context 'when editing a not editable field' do
      let(:body) do
        {
          data: {
            type: 'operations',
            id: operation.id,
            attributes: {
              data: Date.new
            }
          }
        }
      end

      it_behaves_like 'authenticated request', 'PATCH', '/operations/-1'

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when editing only editable fields' do
      let(:body) do
        {
          data: {
            type: 'operations',
            id: operation.id,
            attributes: {
              label: 'new label',
              amount: 999.99,
              comment: 'new comment',
              pointed: true,
              opType: 'income',
              category: 'bank'
            }
          }
        }
      end
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('operations') }

      it { expect(data).to have_jsonapi_attributes(:date, :label, :amount, :comment, :pointed, :opType, :category) }
    end
  end

  describe 'DELETE /operations/{id}' do
    let(:operation) { create(:operation) }

    before do
      operation
      call_endpoint('DELETE', operation_url(operation.id), nil, headers)
    end

    it_behaves_like 'authenticated request', 'DELETE', '/operations/-1'

    it { expect(response).to have_http_status(:method_not_allowed) }
  end
end
