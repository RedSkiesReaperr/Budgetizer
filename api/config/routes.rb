# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount_devise_token_auth_for 'User', at: 'auth'

  jsonapi_resources :categories
  jsonapi_resources :forecasts
  jsonapi_resources :import_configs
  jsonapi_resources :lines
  jsonapi_resources :notes
  jsonapi_resources :objectives
  jsonapi_resources :operations
end
