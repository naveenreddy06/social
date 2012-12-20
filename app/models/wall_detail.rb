class WallDetail
  include Mongoid::Document

  embedded_in :wall

  field :title, :type => String
  field :details, :type => String
  field :priority, :type => Integer
  field :hidden, :type => Boolean, :default => false

  validates :title, :presence => true
  validates :details, :presence => true



end
