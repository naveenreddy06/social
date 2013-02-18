class EmotionType
  include Mongoid::Document

  field :name, :type => String
  
  has_many :emotions
end
