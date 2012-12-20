Relayfan::Application.routes.draw do
  
  root :to => 'unsigned::home#index'
  
  namespace :unsigned do
    resources :home
    resources :search, :only => [:index]
    resources :sessions, :only => [:create]
  end
  
end
