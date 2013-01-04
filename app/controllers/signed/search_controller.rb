class Signed::SearchController < Signed::BaseController

  before_filter :set_flashes_to_null, :check_authentication

  def index
    begin
  		unless params[:keyword].blank?
  	  	current_params = params.merge! :channels => session_all.join(" ")
      	@results = params[:model_type].constantize.search current_params
    	else
  	  	@results = []
    	end
    rescue
    	@results = []
    end
  end

end
