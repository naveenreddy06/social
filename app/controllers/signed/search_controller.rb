class Signed::SearchController < Signed::BaseController

  before_filter :set_flashes_to_null, :check_authentication

  def index
  	unless params[:keyword].blank?
  	  current_params = params.merge! :channels => session_all.join(" ")
      @results = params[:model_type].constantize.search current_params
    else
  	  @results = []
    end
  end

end
