module ApplicationHelper

  def fetch_filters
    case params[:model_type]
    when"Feed"
      FeedType.all.collect{|ft| [ft.post_type, ft.id]}
    when "User"
      UserType.all.collect{|ut| [ut.name, ut.id]}
    else
      []
    end
  end

  def account_setting_hash
    {"Account Management" => ["General", "Status"],  "Edit Wall Profile" => ["Edit Wall Profile","Sort About me list", "Profile Photos"],  "Manage My Friends" => ["Lists Update", "Manage My Friends"],   "Manage Social Circles" => ["Manage Social Circles", "Other's Edit"],   "Manage Fan Pages" => ["Manage Fan Pages", "Other's Edit"] }
  end

end
