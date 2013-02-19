class Emotion
  include Mongoid::Document

  belongs_to :emotion_type
  has_many :user_feeds

  field :name, :type => String

  validates_uniqueness_of :name

end
