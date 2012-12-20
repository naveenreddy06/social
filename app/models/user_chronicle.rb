class UserChronicle
  include Mongoid::Document

  belongs_to :user
  belongs_to :chronicle

end
