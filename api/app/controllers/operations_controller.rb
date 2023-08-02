# frozen_string_literal: true

class OperationsController < ApplicationController
  def create
    render status: :method_not_allowed
  end

  def destroy
    render status: :method_not_allowed
  end
end
