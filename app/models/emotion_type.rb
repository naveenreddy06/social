class EmotionType
  include Mongoid::Document

  has_many :emotions

  field :name, :type => String

  validates_uniqueness_of :name

end
