Relayfan::Application.routes.draw do

  root :to => 'unsigned::home#index'

  namespace :unsigned do
    resources :home do
      collection do
        get "verified", "about_us", "terms", "privacy_cookies", "help_center", "whats_new", "feed_back", "register", "registered_successfully", "help", "forgot_password", "forgot_username", "account_compromised", "account_com_update", "change_password", "set_password", "resend_email", "verify_email"
        post "retreive", "account_compromised_retreive", "change_password_form", "resend_email_click", "create_user"
      end
    end
    resources :search, :only => [:index]
    resources :sessions, :only => [:create]
  end

  namespace :signed do
    resources :users, :except => [:new, :create, :edit] do
     collection do
      get "manage", "account_form", "edit_detail", "hide_wall_detail", "delete", "set_order", "destroy_image", "edit_category", "delete","block","unblock", "connection_types"
      post "add_walls", "add_category_title"
      put "add_walls", "add_photos", "add_category_title"
     end
    end
    resources :feeds do 
      collection do
        get "fetch_form"
      end
    end
  end

end
