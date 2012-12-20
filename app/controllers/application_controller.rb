require 'authenticated_system'
require 'session_loader'
class ApplicationController < ActionController::Base
  before_filter :set_flashes_to_null

  include AuthenticatedSystem
  include SessionLoader
  protect_from_forgery

    def require_authentication
      if !logged_in?
       #session[:coming_from] = request.url
       redirect_to unsigned_home_index_path
      end
    end

    def set_flashes_to_null
    	flash[:error] =  ''
    	flash[:notice] = ''
    end


end
