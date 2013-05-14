class Emotion
  include Mongoid::Document

  belongs_to :emotion_type
  has_many :user_feeds

  field :name, :type => String
  field :emotion_image
  field :order, :type => Integer

  validates_uniqueness_of :name

end
