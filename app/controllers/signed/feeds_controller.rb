class Signed::FeedsController < Signed::BaseController
  
  def index 
    @feeds = Feed.all.entries
  end
  
end
