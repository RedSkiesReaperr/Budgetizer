# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include JSONAPI::ActsAsResourceController

  prepend_before_action :set_locale

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def set_locale
    locale_header = request.headers['locale'].to_sym

    I18n.locale = I18n.available_locales.include?(locale_header) ? locale_header : I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name nickname])
  end
end
