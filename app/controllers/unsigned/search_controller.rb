class Unsigned::SearchController < Unsigned::BaseController
  
  before_filter :set_flashes_to_null, :check_authentication
  
  def index
    @results = params[:model_type].constantize.search params[:keyword], :page => (params[:page] || 1), :per_page=> 1
  end
  
end
