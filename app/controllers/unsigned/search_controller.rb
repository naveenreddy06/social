class Unsigned::SearchController < Unsigned::BaseController
  
  def index
    @results = params[:model_type].constantize.search params[:keyword], :page => (params[:page] || 1), :per_page=> 2
  end
  
end
