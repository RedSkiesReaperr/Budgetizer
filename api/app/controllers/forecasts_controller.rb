# frozen_string_literal: true

class ForecastsController < ApplicationController
  def index
    render status: :ok, json: {
      data: {
        type: 'forecasts',
        attributes: build_payload
      }
    }
  end

  def show
    render status: :method_not_allowed
  end

  private

  def user_forecast
    @user_forecast ||= UserForecast.new(current_user)
  end

  def build_payload
    { income: user_forecast.income,
      vital: user_forecast.vital,
      nonEssential: user_forecast.non_essential,
      saving: user_forecast.saving,
      vitalDiff: user_forecast.vital_diff,
      nonEssentialDiff: user_forecast.non_essential_diff,
      savingDiff: user_forecast.saving_diff,
      vitalDiffPercentage: user_forecast.vital_diff_percentage,
      nonEssentialDiffPercentage: user_forecast.non_essential_diff_percentage,
      savingDiffPercentage: user_forecast.saving_diff_percentage }
  end
end
