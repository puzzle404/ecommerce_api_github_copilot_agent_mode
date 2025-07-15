Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root 'products#index'
  resources :products, only: %i[index show]
  resources :purchases, only: :create
  resources :chat, only: %i[index create]
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'
      get 'token_info', to: 'tokens#show'
      post 'ai/summary', to: 'ai#summary'
      get 'products/top_revenue', to: 'products#top_revenue'
      resources :products
      resources :categories, only: [:index, :create, :update]
      resources :audits, only: [:index]
      resources :administrators, only: [:index, :create]
      resources :customers, only: [:index, :create]

      resources :purchases, only: [:index, :create] do
        collection do
          get :count
        end
      end
    end
  end
end
