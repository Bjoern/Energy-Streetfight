IslandsServer::Application.routes.draw do
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

    resources :ships, :only => [:index]
    resources :resources, :only => [:index]
    resources :islands, :only => [:index]
    resources :problem_types, :only => [:index]
    resources :problems, :only => [:index]
    #resources :resource_types, :only => [:index]

    resource :user, :only => [:show]

    resource :game, :only => [:show]
    resource :ship, :only => [:show]

    resource :vote, :only => [:create, :show]
    resources :meter_readings, :only => [:create, :show]

    get 'votes/summary'
   
    match 'votes/summary' => 'votes#summary', :via => :post

    #legacy interface requested by flash client
    match '/register' => 'users#register'
    match '/login' => 'users#login'

    #match '/update' => 'games#update_game'
    match '/registrieren' => 'games#registrieren'
    root :to => 'games#start'

end
