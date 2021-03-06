require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" }

  default_url_options :host => "localhost:3000"
  root "pages#home"

  authenticate :user, lambda { |u| u.admin? } do
     mount Sidekiq::Web, at: '/sidekiq'
  end

  # Administrative control
  namespace :admin do
    resources :books, only: [:index, :edit, :update, :destroy]
  end

  resources :users, only: [:index, :show]

  resources :books do
    resources :offers, only: [:new, :create]
    resources :comments, only: [:new, :create, :edit, :destroy, :update]
    get 'search', on: :collection
    member do
       get 'buy'
     end
  end

  resources :offers, only: [:destroy, :edit] do
    member do
      get 'accept'
    end
  end

  resources :needs, only: [:new, :create, :destroy]

  resources :contact_forms, only: [:new, :create]

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
