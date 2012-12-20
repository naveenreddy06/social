class FriendRequest
  include Mongoid::Document
  field :user_id, :type => String
  field :friend_id, :type => String
  field :approve, :type => Boolean
  field :reject, :type => Boolean
  field :hold, :type => Boolean

  after_update :set_friend_association

  def set_friend_association
    if self.approve
      u1 = UserFriend.where(:user_id => self.friend_id, :friend_id => self.user_id).first
      u1 = UserFriend.create(:user_id => self.friend_id, :friend_id => self.user_id) unless u1
      u2 = UserFriend.where(:user_id => self.user_id, :friend_id => self.friend_id).first
      u2 = UserFriend.create(:user_id => self.user_id, :friend_id => self.friend_id) unless u2
    end
  end

end
