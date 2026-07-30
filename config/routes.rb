Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :properties
  resources :favorites, only: %i[index create destroy]
  resources :inquiries, only: :create
  resource :dashboard, only: :show, controller: :dashboard

  namespace :admin do
    root "dashboard#index"
    resources :properties, only: %i[index update destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
