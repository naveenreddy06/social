class Login
  include Mongoid::Document
  include ActiveModel::SecurePassword

   embedded_in :user

   field :email, :type => String
   field :master_email, :type => String
   field :password_digest, :type => String

   validates :email, :presence => true
   validates_length_of :password, minimum: 5, maximum: 15, :confirmation => true
   validate :unique_email, :on => :create

   has_secure_password


   def unique_email
     self.errors.add(:email, "Already taken.") if User.where("login.email" =>  self.email).count > 0
   end

end
