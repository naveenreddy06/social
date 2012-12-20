class Connection
   include Mongoid::Document

   belongs_to :user

   field :category_title, :type => String
   field :hidden, :type => Boolean, :default => false

   validate :title_check

   before_destroy :release_friends


   def release_friends
     friendrequests =  UserFriend.where("connection_id" => self.id.to_s)
      friendrequests.each do |fr|
        fr.update_attributes("connection_id" => nil)
      end
   end


   def title_check
     if self.category_title.blank?
        self.error("feed", "Nonsense")
     end
   end

end
