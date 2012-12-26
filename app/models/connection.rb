class Connection
   include Mongoid::Document

   belongs_to :user

   field :category_title, :type => String
   field :hidden, :type => Boolean, :default => false

   validates :category_title, :presence => true

   before_destroy :release_friends


   def release_friends
     friendrequests =  UserFriend.where("connection_id" => self.id.to_s)
      friendrequests.each do |fr|
        fr.update_attributes("connection_id" => nil)
      end
   end

end
