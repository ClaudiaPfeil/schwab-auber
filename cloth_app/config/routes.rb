ClothApp::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => "welcome#home"

  resources :bank_details do
    get :payment_method, :on => :member
  end

  resources :contents do
      get :publish, :on => :member
  end

  resources :packages do
      get :search, :on => :collection
      get :order, :on => :member
      get :show_24, :on => :collection
  end

  resources :payments do
    get :confirm_prepayment, :on => :member
    get :all_unconfirmed, :on => :collection
  end

  resources :profiles do
    get :search, :on => :collection
    get :order_cartons, :on => :member
    get :export_histories, :on => :collection
    get :export_cartons, :on => :collection
  end

  resources :users do
    member do
      put :suspend
      put :unsuspend
      delete :purge
    end

    get :search, :on => :collection
  end

  resources :addresses
  resources :bills
  resources :categories
  resources :contacts
  resources :helps
  resources :impressums
  resources :orders
  resources :options
  resources :prices
  resources :searches
  
  

  resource :session, :only => [:new, :create, :destroy]


  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'signup' => 'users#new', :as => :signup
  match 'activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil
  match 'landing_page' => 'landing_pages#show', :as => :landing_page
  match ':controller/:action/:preview'
  match 'membership' => 'welcome#membership', :as => :membership
  match 'dashboard' => 'welcome#dashboard', :as => :dashboard
  match 'profiles/invite_friend' => 'profiles#invite_friend', :as => 'invite_friend'

  


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
