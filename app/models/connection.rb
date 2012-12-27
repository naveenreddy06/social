class Connection
   include Mongoid::Document

   belongs_to :user

   field :category_title, :type => String
   field :hidden, :type => Boolean, :default => false

   validates_length_of :category_title, minimum: 1, maximum: 28, :on => :update

   before_destroy :release_friends


   def release_friends
     friendrequests =  UserFriend.where("connection_id" => self.id.to_s)
      friendrequests.each do |fr|
        fr.update_attributes("connection_id" => nil)
      end
   end

end
