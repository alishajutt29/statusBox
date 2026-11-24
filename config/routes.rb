Rails.application.routes.draw do
  resources :registrations, only: [:new, :create]
  get "dashboard/index"
  resources :todos do
    member do
      patch :complete
      patch :cancel
      patch :restore
    end
  end
  resource :session
  resources :passwords, param: :token
  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
end
