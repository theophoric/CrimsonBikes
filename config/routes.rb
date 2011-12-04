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
  match 'howitworks'                    => 'pages#how_it_works'       , :as => "how_it_works"
  match 'locations'                     => 'pages#locations'          , :as => "locations"
  match 'hello'                         => 'pages#hello'  , :as => 'hello'
  
  match 'bikes/reserve' => "program#reserve", :as => "create_reservation"
  
  match 'bikes/open_ticket'    => 'program#open_ticket', :as => "open_ticket"
  match 'bikes/close_ticket/:id'    => 'program#close_ticket', :as => "close_ticket"
  
  match 'user/account' => 'program#account', :as => "account"

  scope "/admin", :controller => :program do                                              
    match '/'                             => :admin          , :as => "admin"
    match ':_class/:_id/edit'             => :edit           , :as => "object_edit"
    match ':_class/:_id/update'           => :update         , :as => "object_update"
    match ':_class/:_id/destroy'          => :destroy        , :as => "object_destroy"
    match ':_class/create'                => :create         , :as => "object_create"
    match ':_class/manage'                => :manage         , :as => "object_manage"
    match ':_class/new'                   => :new            , :as => "object_new"
    match ':_class/:_id/flag'             => :flag           , :as => "object_flag"
    match 'create_admin/:_id'             => :create_admin   , :as => "create_admin"
    match 'activate_account/:_id'         => :activate_account, :as => "activate_account"
  end
  
  scope :controller => :messages do
    match 'notification_new'  => :notification_new, :as => "notification_new"
    match 'notification_send' => :notification_send, :as => "notification_send"
    match 'feedback_send'     => :feedback_send, :as => "feedback_send"
  end
  
  scope :controller => :checkouts do
    match 'process_checkout/:membership_type'   => :process_checkout, :as => "process_checkout"
    match 'process_response'                    => :process_response, :as => "process_response", :protocol => "https://"
  end
end
