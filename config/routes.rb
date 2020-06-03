Rails.application.routes.draw do
  root to: 'sessions#new'
  namespace :admin do
    resources :users
  end
  resources :tasks
  resources :sessions
  resources :users
end
