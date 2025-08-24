Rails.application.routes.draw do
  root "polls#index"
  resources :polls
  devise_for :users
  resources :users, only: [:index, :new, :create, :destroy]



  get "up" => "rails/health#show", as: :rails_health_check
end
