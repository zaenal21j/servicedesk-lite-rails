Rails.application.routes.draw do
  get "tickets/index"
  get "tickets/show"
  get "tickets/new"
  get "tickets/edit"
  get "customers/index"
  get "customers/show"
  get "customers/new"
  get "customers/edit"
  get "dashboard/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
  resources :customers
  resources :tickets
  namespace :api do
    namespace :v1 do
      resources :tickets, only: %i[index show create update]
    end
  end
end
