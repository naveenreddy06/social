class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
   embedded_in :feed
   belongs_to :user
   belongs_to :comment_mood

   field :comment
   validates_presence_of :comment
   
   after_create :update_parent
   
   def update_parent
     feed = self.feed
     feed.updated_at = Time.now
     feed.save()
   end
end
