HemlockFrontend::Application.routes.draw do
  root :to => 'searches#search'  
  authenticated :user do
    root :to => 'searches#search'
  end
  
  devise_scope :user do 
    root :to => "devise/sessions#new"
  end

  devise_for :users

  match 'about', :controller => 'static_pages', :action => 'about', :as => :about
  match 'search', :controller => 'searches', :action => 'search', :as => :search
  match 'searches/ajax_load_results', :controller => 'searches'
  
  namespace :api do
    devise_for :users, :controllers => {sessions:'sessions'} # custom controller for API token access
  end
  
  namespace :admin do
    resources :hemlock_tenants, :hemlock_systems, :hemlock_users, :hemlock_roles
  end

  resources :users
end
