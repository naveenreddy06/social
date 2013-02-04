class AbusePost
  include Mongoid::Document

  belongs_to :user
  belongs_to :feed_type

  store_in collection: "feeds"
  default_scope -> {where(:feed_count.gt => 0) }

  def abuse_users
    user_ids =  UserFeed.where(:abuse => true, :feed_id => self.id).collect(&:user_id)
    User.where(:id.in => user_ids).collect{|user| [user.first_name + " " + user.last_name, user.id]}
  end

end
