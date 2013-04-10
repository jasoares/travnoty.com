require 'subdomain'
require 'api_version'

Travnoty::Application.routes.draw do

  if ENV['LAUNCH']
    get 'sign_out' => 'sessions#destroy', :as => 'sign_out'
    get 'sign_in' => 'sessions#new', :as => 'sign_in'
    post 'sessions' => 'sessions#create'

    get 'sign_up' => 'users#new', :as => 'sign_up'
    get 'profile' => 'accounts#settings', :as => 'profile'
    post 'users' => 'users#create'
    get 'users/:id/confirm_email/:confirmation_token' => 'users#confirm_email', :as => 'confirm_email'
    post 'users/:id/request_verification' => 'users#request_verification', :as => 'request_verification'

    get "account/settings" => 'accounts#settings', as: 'account'
    get "account/notifications" => 'accounts#notifications', as: 'account_notifications'
    get "account/billing" => 'accounts#billing', as: 'account_billing'
    get "account/payments" => 'accounts#payments', as: 'account_payments'
    get "account/travian_accounts" => 'accounts#travian_accounts', as: 'travian_accounts'

    resources :users, only: [:new, :create, :show, :edit, :update]
    resources :passwords, only: [:new, :create, :edit, :update]
  end

  resources :pre_subscriptions, only: [:new, :create]

  scope :module => :api, constraints: Subdomain[:api], defaults: { format: :json } do
    scope :module => :v1, constraints: ApiVersion[version: 1, default: true] do
      get 'hubs' => 'hubs#index'
      get 'hubs/:id' => 'hubs#show'
      get 'hubs/:id/servers' => 'hubs#servers'
      get 'hubs/:id/supported_servers' => 'hubs#supported_servers'
      get 'servers' => 'servers#index'
      get 'servers/:id' => 'servers#show', id: /\d+/
      get 'servers/active' => 'servers#active'
      get 'servers/archived' => 'servers#archived'
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  if ENV['LAUNCH']
    root :to => 'home#welcome'
  else
    root :to => 'home#pre_welcome'
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
