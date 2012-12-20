class UserCircle
  include Mongoid::Document

  #Start Associations ----------------------------------------------------

    belongs_to :user
    belongs_to :circle

  #End Associations ------------------------------------------------------

  #Start attributes for circle form --------------------------------------

     field :admin, :type => Boolean, :default => false
     field :approve, :type => Boolean, :default => false
     field :reject, :type => Boolean, :default => false

  #End attributes for circle form ----------------------------------------

end
