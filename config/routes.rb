RorBlog::Application.routes.draw do

  get "password_resets/new"

  resources :sessions, only: :create
  resources :users
  resources :posts, except: :index
  resources :password_resets
  resources :comments, only: [:create, :destroy]
  resources :tags, only: :show

  match 'signup',   to: 'users#new'
  match 'activate/:id', to: 'users#activate', as: 'activate'
  match 'signin',   to: 'sessions#new'
  match 'signout',  to: 'sessions#destroy', via: :delete

  root :to => 'posts#index'

  # Static pages
  match 'about' => "static_pages#about"

  mount Markitup::Rails::Engine, at: 'markitup', as: 'markitup'

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
