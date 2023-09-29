# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Operations' do
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'POST /operations' do
    before do
      post operations_url, headers:
    end

    it { expect(response).to have_http_status(:method_not_allowed) }
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
      get operations_url(filters), headers:
    end

    context 'without filters' do
      let(:filters) { {} }

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
      get operation_url(operation_id), headers:
    end

    context 'when operation does not exists' do
      let(:operation_id) { -1 }

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
      patch operation_url(operation.id), headers:, params: body.to_json
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
      delete operation_url(operation.id), headers:
    end

    it { expect(response).to have_http_status(:method_not_allowed) }
  end
end
