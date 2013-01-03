Relayfan::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'unsigned::home#index'

  namespace :unsigned do
    resources :home do
      collection do
        get "verified", "about_us", "terms", "privacy_cookies", "help_center", "whats_new", "feed_back", "register", "registered_successfully", "help", "forgot_password", "forgot_username", "account_compromised", "account_com_update", "change_password", "set_password", "resend_email", "verify_email"
        post "retreive", "account_compromised_retreive", "change_password_form", "resend_email_click", "create_user"
        put "change_password_form"
      end
    end
    resources :search, :only => [:index]
    resources :sessions, :only => [:create] do
      collection do
        get "logout"
      end
    end
  end

  namespace :signed do
    resources :search, :only => [:index]
    resources :users, :except => [:new, :create, :edit] do
     collection do
      get "manage", "account_form", "edit_detail", "hide_wall_detail", "delete", "set_order", "destroy_wall_image", "edit_category", "delete","block","unblock", "connection_types", "edit_circles", "hide_circle", "about", "sort_about", "get_members", "get_circle", "delete_circle", "set_order", "add_circle_photos", "destroy_image", "delete_user", "approve_user", "reject_user", "unjoin_user", "edit_chronicles", "delete_chronicle", "unfollow_chronicle", "chronicle_content", "fetch_older_chronicles", "connection_content", "connection_replace","add_follow", "add_friend", "accept", "delete_friend", "not_now", "hide_all", "delete_all","join_request", "delete_connection", "get_circle_details", "about_circle", "circle_members", "circle_members_replace", "join_circle", "unjoin_circle" 

      post "add_walls", "add_category_title", "add_circles_title", "add_circle_details", "add_chronicles_title"
      put "add_walls", "add_photos", "add_category_title", "add_circles_title", "add_circle_photos", "add_circle_details", "add_chronicles_title"
     end
    end
    resources :feeds do
      collection do
        get "fetch_form", "fetch_friends", "add_comment", "feed_tag", "deletepost"
      end
    end
    resources :messages do
      collection do
        get "friend_message","fetch_older_messages"
      end
   end
  end

end
