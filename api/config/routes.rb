# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  jsonapi_resources :operations
  jsonapi_resources :lines
  jsonapi_resources :budgets
  jsonapi_resources :objectives
end
