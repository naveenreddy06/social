class CircleDetail
  include Mongoid::Document

  belongs_to :circle

  field :title, :type => String
  field :details, :type => String
  field :priority, :type => Integer

  validates :title, :presence => true
  validates :details, :presence => true

end
