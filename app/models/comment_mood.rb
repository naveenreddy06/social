class CommentMood
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :enabled_image
  field :disabled_image
  field :order, :type => Integer

end
