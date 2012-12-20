module ApplicationHelper
  
  def fetch_filters
    case params[:model_type]
    when"Feed"
      FeedType.all.collect{|ft| [ft.post_type, ft.id]}
    else
      []
    end
  end
  
end
