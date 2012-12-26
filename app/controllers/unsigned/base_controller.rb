module Unsigned
  class BaseController < ApplicationController
    
    def check_authentication
      if current_user
        redirect_to signed_feeds_path
      end
    end
    
  end
end