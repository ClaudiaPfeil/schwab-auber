ClothApp::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => "welcome#home"
  
  resources :contents do
      get :publish, :on => :member
  end
  resources :categories
  resources :profiles do
    get :search, :on => :collection
  end
  resources :packages do
      get :search, :on => :collection
      get :order, :on => :member
  end
  resources :contacts
  resources :searches
  resources :helps
  resources :impressums
  resources :orders
  resources :bills
  resources :addresses

  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'signup' => 'users#new', :as => :signup
  match 'activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil
  match 'landing_page' => 'landing_pages#show', :as => :landing_page
  match ':controller/:action/:preview'
 
  resources :users do
    member do
      put :suspend
      put :unsuspend
      delete :purge
    end

    get :search, :on => :collection
  end

  resource :session, :only => [:new, :create, :destroy]


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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
