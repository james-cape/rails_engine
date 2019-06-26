Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      namespace :merchants do
        # resources :most_revenue, only: [:index]
        get '/most_revenue', to: 'most_revenue#index'
      end

      get '/customers/:id/invoices', to: 'customers/invoices#index'
      # resources :customers,     only: [:index, :show] do
      #   resources :invoices, only: :index
      # end
      resources :customers,     only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :invoices,      only: [:index, :show]
      resources :items,         only: [:index, :show]
      resources :merchants,     only: [:index, :show]
      resources :transactions,  only: [:index, :show]
    end
  end
end
