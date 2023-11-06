# frozen_string_literal: true

module AuthenticationHelpers
  def call_endpoint(method, url, params, headers)
    begin
      post user_session_url, params: { email: user.email, password: user.password }
      authenticated_headers = headers.merge(authenticated_headers(response.headers))
    rescue StandardError => e
      raise "Something went wrong while authenticating: #{e}"
    end

    send(method.downcase.to_sym, url, params:, headers: authenticated_headers)
  end

  def authenticated_headers(source)
    {
      'access-token': source['access-token'],
      'token-type': source['token-type'],
      client: source['client'],
      uid: source['uid'],
      expiry: source['expiry']
    }
  end
end
