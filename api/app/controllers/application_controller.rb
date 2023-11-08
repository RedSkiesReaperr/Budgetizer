# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include DeviseTokenAuth::Concerns::SetUserByToken
  include JSONAPI::ActsAsResourceController

  prepend_before_action :set_locale

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?

  protected

  def set_locale
    locale_header = request.headers['Locale'].try(:to_sym)

    return unless I18n.available_locales.include?(locale_header)

    I18n.locale = locale_header
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name nickname])
  end
end
