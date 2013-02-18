class Emotion
  include Mongoid::Document

  belongs_to :emotion_type

  field :name, :type => String
 
end
