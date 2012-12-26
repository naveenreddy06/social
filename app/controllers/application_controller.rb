require 'authenticated_system'
require 'session_loader'
class ApplicationController < ActionController::Base
  before_filter :set_flashes_to_null

  include AuthenticatedSystem
  include SessionLoader
  protect_from_forgery

    def set_flashes_to_null
    	flash[:error] =  ''
    	flash[:notice] = ''
    end


end
