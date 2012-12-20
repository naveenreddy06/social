class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
   embedded_in :feed
   belongs_to :user

   field :comment
   validates_presence_of :comment
end
