class UserFeed
  include Mongoid::Document
  belongs_to :user
  belongs_to :feed

  field :cool, :type => Boolean
  field :favorite, :type => Boolean
  field :hidden, :type => Boolean, :default => false
  field :shared, :type => Boolean, :default => false

end
