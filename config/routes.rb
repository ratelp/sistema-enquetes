Rails.application.routes.draw do
  root "polls#index"
  devise_for :users
  resources :users, only: [:index, :new, :create, :destroy]

  resources :polls, except: [:edit, :update, :destroy] do
    resources :votes, only: :create
    member do
      patch :close
    end
  end
  
  get "ownPolls" => "polls#ownPolls"
  get "votedPolls" => "polls#votedPolls"

  get "up" => "rails/health#show", as: :rails_health_check
end
