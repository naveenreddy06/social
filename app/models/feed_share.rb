class FeedShare
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :feed
  belongs_to :user
  
  field :parent_id
  field :original_feed_id

  
end
