# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lines' do
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'GET /lines' do
    let(:lines) { create_list(:line, 4) }
    let(:data) { JSON.parse(response.parsed_body)['data'] }

    before do
      lines
      get lines_url, headers:
    end

    it { expect(response).to have_http_status(:ok) }

    it { expect(data).to all(have_link(:self)) }

    it { expect(data).to all(have_type('lines')) }

    it { expect(data).to all have_jsonapi_attributes(:label, :amount, :lineType, :category).exactly }

    it { expect(data).to all have_relationships(:budget).exactly }
  end

  describe 'GET /lines/{id}' do
    let(:line) { create(:line) }

    before do
      line
      get line_url(line_id), headers:
    end

    context 'when line does not exists' do
      let(:line_id) { -1 }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when line exists' do
      let(:line_id) { line.id }
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('lines') }

      it { expect(data).to have_jsonapi_attributes(:label, :amount, :lineType, :category).exactly }

      it { expect(data).to have_relationships(:budget).exactly }
    end
  end

  describe 'DELETE /lines/{id}' do
    it { expect { delete line_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end

  describe 'PATCH /lines/{id}' do
    it { expect { patch line_url(1), headers: }.to raise_error(ActionController::RoutingError) }
  end
end
