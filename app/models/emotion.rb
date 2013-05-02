class Emotion
  include Mongoid::Document

  belongs_to :emotion_type
  has_many :user_feeds

  field :name, :type => String
  field :enabled_image
  field :disabled_image
  field :order, :type => Integer

  validates_uniqueness_of :name

end
