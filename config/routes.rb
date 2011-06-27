Crimson2::Application.routes.draw do
  resources :profiles

  devise_for :users
  
  root :to => 'pages#welcome'
  
  
  
  match ':_class/:_id/show'             => 'program#show'            , :as => "object_show"
  match ':_class/index'                 => 'program#index'           , :as => "object_index"
  match 'welcome'                       => 'pages#welcome'            , :as => "welcome"
  match 'about'                         => 'pages#about'              , :as => "about"
  match 'contact'                       => 'pages#contact'              , :as => "contact"
  match 'blog'                          => 'pages#blog'               , :as => "blog"
  
  match 'bikes/reserve' => "program#reserve", :as => "create_reservation"
  
  match 'user/account' => 'program#account', :as => "account"

  scope "/admin", :controller => :program do                                              
    match '/'                             => :admin          , :as => "admin"
    match ':_class/:_id/edit'             => :edit           , :as => "object_edit"
    match ':_class/:_id/update'           => :update         , :as => "object_update"
    match ':_class/:_id/destroy'          => :destroy        , :as => "object_destroy"
    match ':_class/create'                => :create         , :as => "object_create"
    match ':_class/manage'                => :manage         , :as => "object_manage"
    match ':_class/new'                   => :new            , :as => "object_new"
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
