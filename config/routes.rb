Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :customers,     only: [:index]
      resources :invoice_items, only: [:index]
      resources :invoices,      only: [:index]
      resources :items,         only: [:index]
      resources :merchants,     only: [:index]
      resources :transactions,  only: [:index]
    end
  end
end
