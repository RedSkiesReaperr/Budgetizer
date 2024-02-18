# frozen_string_literal: true

class ObjectivesController < ApplicationController
  def index
    objective = current_user.objective

    render status: :ok, json: {
      data: [payload(objective)]
    }
  end

  def show
    render status: :method_not_allowed
  end

  private

  def payload(objective)
    {
      id: objective.id,
      type: 'objectives',
      links: { self: "http://localhost:3000/objectives/#{objective.id}" },
      attributes: {
        vital: objective.vital,
        nonEssential: objective.non_essential,
        saving: objective.saving
      }
    }
  end
end
