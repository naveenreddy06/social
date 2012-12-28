class FeedType
  include Mongoid::Document
  include Mongoid::Timestamps

   has_many :feeds , validate: false

   field :post_type, :type => String
   validates :post_type, :uniqueness => true

   def post_type_with_image
      self.post_type + "image_tag"
   end


end
