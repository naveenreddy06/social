class Signed::FeedsController < Signed::BaseController
  
  def index 
    @feed = Feed.new
    @feeds = Feed.all.entries
  end
  
end
