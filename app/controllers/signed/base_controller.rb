class Signed::BaseController < ApplicationController
  
  def check_authentication
    if !current_user
      session[:coming_from] = request.url
      redirect_to root_path
    end
  end
  
end
