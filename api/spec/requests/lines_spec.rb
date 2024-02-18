# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lines' do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'GET /lines' do
    let(:lines) { create_list(:line, 4, user:) }
    let(:data) { JSON.parse(response.parsed_body)['data'] }

    before do
      lines
      call_endpoint('GET', lines_url, nil, headers)
    end

    it_behaves_like 'authenticated request', 'GET', '/lines'

    it { expect(response).to have_http_status(:ok) }

    it { expect(data).to all(have_link(:self)) }

    it { expect(data).to all(have_type('lines')) }

    it { expect(data).to all have_jsonapi_attributes(:label, :amount, :lineType, :category).exactly }
  end

  describe 'GET /lines/{id}' do
    let(:line) { create(:line, user:) }

    before do
      line
      call_endpoint('GET', line_url(line_id), nil, headers)
    end

    context 'when line does not exists' do
      let(:line_id) { -1 }

      it_behaves_like 'authenticated request', 'GET', '/lines/-1'

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when line exists' do
      let(:line_id) { line.id }
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('lines') }

      it { expect(data).to have_jsonapi_attributes(:label, :amount, :lineType, :category).exactly }
    end
  end

  describe 'DELETE /lines/{id}' do
    let(:line) { create(:line, user:) }

    before do
      line
      call_endpoint('DELETE', line_url(line.id), nil, headers)
    end

    it_behaves_like 'authenticated request', 'DELETE', '/lines/-1'

    it { expect(response).to have_http_status(:no_content) }

    it 'removes the line' do
      expect { Line.find(line.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH /lines/{id}' do
    let(:line) { create(:line, user:) }

    before do
      line
      call_endpoint('PATCH', line_url(line.id), body.to_json, headers)
    end

    context 'when editing a not editable field' do
      let(:body) do
        {
          data: {
            type: 'lines',
            id: line.id,
            attributes: {
              data: Date.new
            }
          }
        }
      end

      it_behaves_like 'authenticated request', 'PATCH', '/lines/-1'

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when editing only editable fields' do
      let(:body) do
        {
          data: {
            type: 'lines',
            id: line.id,
            attributes: {
              label: 'new label',
              amount: 999.99,
              lineType: 'income',
              category: 'bank'
            }
          }
        }
      end

      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('lines') }

      it { expect(data).to have_jsonapi_attributes(:label, :amount, :lineType, :category) }
    end
  end
end
