class FollowUser
  include Mongoid::Document

  field :user_id
  field :following_id

end
