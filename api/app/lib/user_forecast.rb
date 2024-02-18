# frozen_string_literal: true

class UserForecast
  def initialize(user)
    @user = user
  end

  def income
    lines.income.sum(&:amount)
  end

  def vital
    lines.vital.sum(&:amount)
  end

  def non_essential
    lines.non_essential.sum(&:amount)
  end

  def saving
    income - (vital + non_essential)
  end

  def vital_diff
    vital - vital_value
  end

  def non_essential_diff
    non_essential - non_essential_value
  end

  def saving_diff
    saving - saving_value
  end

  def vital_diff_percentage
    (vital_diff / vital_value) * 100
  end

  def non_essential_diff_percentage
    (non_essential_diff / non_essential_value) * 100
  end

  def saving_diff_percentage
    (saving_diff / saving_value) * 100
  end

  private

  def lines
    @lines ||= @user.lines
  end

  def objective
    @objective ||= @user.objective
  end

  def vital_value
    objective.vital * income / 100
  end

  def non_essential_value
    objective.non_essential * income / 100
  end

  def saving_value
    objective.saving * income / 100
  end
end
