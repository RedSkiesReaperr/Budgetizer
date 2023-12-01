# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes' do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  describe 'GET /notes' do
    let(:notes) { create_list(:note, 4, user:) }
    let(:data) { JSON.parse(response.parsed_body)['data'] }

    before do
      call_endpoint('GET', notes_url, nil, headers)
    end

    it_behaves_like 'authenticated request', 'GET', '/notes'

    it { expect(response).to have_http_status(:ok) }

    it { expect(data).to all(have_link(:self)) }

    it { expect(data).to all(have_type('notes')) }

    it { expect(data).to all have_jsonapi_attributes(:title, :description, :month, :year).exactly }

    it { expect(data).to all have_relationships(:budget).exactly }
  end

  describe 'GET /notes/{id}' do
    let(:note) { create(:note, user:) }

    before do
      call_endpoint('GET', note_url(note_id), nil, headers)
    end

    context 'when note does not exists' do
      let(:note_id) { -1 }

      it_behaves_like 'authenticated request', 'GET', '/notes/-1'

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when note exists' do
      let(:note_id) { note.id }
      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('notes') }

      it { expect(data).to have_jsonapi_attributes(:title, :description, :month, :year).exactly }

      it { expect(data).not_to have_relationships }
    end
  end

  describe 'POST /notes' do
    before do
      call_endpoint('POST', notes_url, body.to_json, headers)
    end

    context 'when a mandatory field is missing' do
      let(:body) do
        {
          data: {
            type: 'notes',
            attributes: {
              title: 'test title',
              description: 'test desc',
              month: 5
            }
          }
        }
      end

      it_behaves_like 'authenticated request', 'POST', '/notes'

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when all fields are fulfilled' do
      let(:body) do
        {
          data: {
            type: 'notes',
            attributes: {
              title: 'test title',
              description: 'test desc',
              month: 5,
              year: 2023
            }
          }
        }
      end

      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:created) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('notes') }

      it { expect(data).to have_jsonapi_attributes(:title, :description, :month, :year) }
    end
  end

  describe 'DELETE /notes/{id}' do
    let(:note) { create(:note, user:) }

    before do
      call_endpoint('DELETE', note_url(note.id), nil, headers)
    end

    it_behaves_like 'authenticated request', 'DELETE', '/notes/-1'

    it { expect(response).to have_http_status(:no_content) }

    it 'removes the note' do
      expect { Note.find(note.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH /notes/{id}' do
    let(:note) { create(:note, user:) }

    before do
      call_endpoint('PATCH', note_url(note.id), body.to_json, headers)
    end

    context 'when editing a not editable field' do
      let(:body) do
        {
          data: {
            type: 'notes',
            id: note.id,
            attributes: {
              month: 1
            }
          }
        }
      end

      it_behaves_like 'authenticated request', 'PATCH', '/notes/-1'

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when editing only editable fields' do
      let(:body) do
        {
          data: {
            type: 'notes',
            id: note.id,
            attributes: {
              title: 'new title',
              description: 'new description'
            }
          }
        }
      end

      let(:data) { JSON.parse(response.parsed_body)['data'] }

      it { expect(response).to have_http_status(:ok) }

      it { expect(data).to have_link(:self) }

      it { expect(data).to have_type('notes') }

      it { expect(data).to have_jsonapi_attributes(:title, :description, :month, :year) }
    end
  end
end
