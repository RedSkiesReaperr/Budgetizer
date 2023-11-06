# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'authenticated request' do |method, url|
  context 'when user is not logged in' do
    let(:headers) do
      {
        'Content-Type': 'application/vnd.api+json',
        'access-token': nil,
        'token-type': nil,
        client: nil,
        uid: nil,
        expiry: 0
      }
    end

    before do
      send(method.downcase, url, params: nil, headers:)
    end

    it { expect(response).to have_http_status(:unauthorized) }

    it { expect(response.parsed_body).to have_key('errors') }
  end

  context 'when user is logged in' do
    let(:user) { create(:user) }
    let(:headers) do
      {
        'Content-Type': 'application/vnd.api+json',
        'access-token': nil,
        'token-type': 'Bearer',
        client: nil,
        uid: nil,
        expiry: 0
      }
    end

    before do
      post user_session_url, params: { email: user.email, password: user.password }
      headers = {
        'Content-Type': 'application/vnd.api+json',
        'access-token': response.headers['access-token'],
        'token-type': response.headers['token-type'],
        client: response.headers['client'],
        uid: response.headers['uid'],
        expiry: response.headers['expiry']
      }

      send(method.downcase, url, params: body, headers:)
    end

    it { expect(response).not_to have_http_status(:unauthorized) }

    it { expect(response).to have_header('access-token') }

    it { expect(response).to have_header('token-type') }

    it { expect(response).to have_header('client') }

    it { expect(response).to have_header('uid') }

    it { expect(response).to have_header('expiry') }
  end
end
