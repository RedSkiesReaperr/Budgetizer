# frozen_string_literal: true

class CategoriesController < ApplicationController
  def update
    render status: :method_not_allowed
  end
end
