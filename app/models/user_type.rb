class UserType
  include Mongoid::Document
   has_many :users, validate: false
   field :name, :type => String
end
