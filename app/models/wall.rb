class Wall
  include Mongoid::Document
  embedded_in :user
  embeds_many :wall_details
  accepts_nested_attributes_for :wall_details, :allow_destroy => true
  validates_associated :wall_details

end
