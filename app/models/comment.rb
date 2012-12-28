class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
   belongs_to :feed
   belongs_to :user

   field :comment
   validates_presence_of :comment
   
   after_create :update_parent
   
   def update_parent
     feed = self.feed
     feed.updated_at = Time.now
     feed.save()
   end
end
