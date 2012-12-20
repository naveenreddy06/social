Relayfan::Application.routes.draw do
  
  root :to => 'unsigned::home#index'
  
  namespace :unsigned do
    resources :home do
      collection do
        get "verified", "about_us", "terms", "privacy_cookies", "help_center", "whats_new", "feed_back", "register", "registered_successfully", "help", "forgot_password", "forgot_username", "account_compromised", "account_com_update", "change_password", "set_password", "resend_email"
        post "retreive", "account_compromised_retreive", "change_password_form", "resend_email_click"
      end
    end
    resources :search, :only => [:index]
    resources :sessions, :only => [:create]
  end
  
end
