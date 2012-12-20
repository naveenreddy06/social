class Message
  include Mongoid::Document
  include Mongoid::Timestamps
   belongs_to :user

   field :message
   validates_presence_of :message
   field :friend_id, :type => String
   field :read, :type => Boolean
end
