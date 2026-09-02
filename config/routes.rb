Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"
      post "auth/logout", to: "auth#logout"
      get "auth/profile", to: "auth#profile"

      get "ice-config", to: "ice_config#show"

      resources :devices, only: [:index, :create, :update, :destroy]
      resources :calls, only: [:index, :create, :update]
      resources :rooms, only: [:index, :create, :update, :destroy]
    end
  end
end
