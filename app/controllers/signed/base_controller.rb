class Signed::BaseController < ApplicationController
  
  def check_authentication
    if !current_user
      redirect_to root_path
    end
  end
  
end
