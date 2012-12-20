module ApplicationHelper

  def fetch_filters
    case params[:model_type]
    when"Feed"
      FeedType.all.collect{|ft| [ft.post_type, ft.id]}
    else
      []
    end
  end

  def account_setting_hash
    {"Account Management" => ["General", "Status"],  "Edit Wall Profile" => ["Edit Wall Profile","Sort About me list", "Profile Photos"],  "Manage Connections" => ["Lists Update", "Manage Connections"],   "Manage Circles" => ["Manage Circles", "Other's Edit"],   "Manage Chronicles" => ["Manage Chronicles", "Other's Edit"] }
  end

end
