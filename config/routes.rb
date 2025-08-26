Rails.application.routes.draw do
  root "polls#index"
  devise_for :users
  resources :users, only: [:index, :new, :create, :destroy]

  resources :polls do
    resources :votes, only: :create
  end
  
  get "ownPolls" => "polls#ownPolls"
  get "votedPolls" => "polls#votedPolls"



  get "up" => "rails/health#show", as: :rails_health_check
end
