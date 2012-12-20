class FeedType
  include Mongoid::Document

   has_many :feeds , validate: false

   field :post_type, :type => String

   def post_type_with_image
      self.post_type + "image_tag"
   end


end
