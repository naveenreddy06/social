class User
  include Mongoid::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks
  require 'stalker'

  embeds_one :account_setting, validate: false #disables validation of account_settings during initialization
  embeds_one :login, validate: false           #disables validation of login during initialization
  embeds_one :wall, validate: false
  # has_one :image, validate: false
  has_many :banner_images, validate: false
  has_many :profile_images, validate: false
  belongs_to :user_type

  has_many :connections, validate: false
  has_many :chronicles, validate: false
  has_many :feeds, validate: false
  has_many :user_feeds, validate: false
  has_many :user_chronicles, validate: false
  has_many :circles, validate: false
  has_many :user_circles, validate: false
  has_many :user_friends, validate: false
  has_many :messages, validate: false


    # accepts child class attributes
  accepts_nested_attributes_for  :account_setting
  accepts_nested_attributes_for  :login
  accepts_nested_attributes_for  :wall
  accepts_nested_attributes_for :profile_images, :reject_if => proc { |attributes| attributes['profile_image'].blank? }
  accepts_nested_attributes_for :banner_images, :reject_if => proc { |attributes| attributes['banner_image'].blank? }
   #associating  validations of child class on run time in order to avoid conflicts
  validates_associated :account_setting, :if => lambda {!self.account_setting.nil? and (self.account_setting.new_record? or self.account_setting.changed?)}, :on => :update
  validates_associated :login, :if => lambda {self.login.new_record? or self.login.changed?}
  validates_associated :wall, :if => lambda {!self.wall.nil? and (self.wall.new_record? or self.wall.changed?)}, :on => :update


  #attributes for registration form
   field :display_name, :type => String
   field :first_name, :type => String
   field :last_name, :type => String
   field :birthday, :type => Date
   field :phone, :type => Integer
   field :verified, :type => Boolean
   field :verification_token, :type => String
   field :time_zone, :type => String

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  after_validation :set_verification_token
  after_create :send_verification


  def feed_channels
    UserFriend.where("friend_id" => self.id).collect(&:connection_id) + self.user_circles.collect{|cir| cir.circle_id.to_s}  + self.my_friends.collect{|usr| usr.id.to_s} + self.following + self.user_chronicles.collect{|chronicle| chronicle.chronicle_id.to_s} + [self.id.to_s] + self.connections.collect{|conn| conn.id.to_s} + self.chronicles.collect{|chr| chr.id.to_s}
  end

  def my_circles
    self.circles.all
  end

  def others_circles
    Circle.where(:id.in => self.user_circles.collect(&:circle_id), :user_id.ne => self.id)
  end

  def my_chronicles
    self.chronicles.all
  end

  def other_chronicles
    Chronicle.where(:id.in => self.user_chronicles.collect(&:chronicle_id), :user_id.ne => self.id, :permission => true)
  end

  def all_friends
    User.where(:_id.in => self.user_friends.collect(&:friend_id))
  end

  # getting all the friends who are not blocked,should check in both sides so query is on UserFriend

  def my_friends
      User.where(:_id.in => UserFriend.where(:friend_id => self.id, :block.in => [nil, false]).collect(&:user_id))
  end

   def blocked_friends
      User.where(:_id.in => UserFriend.where(:friend_id => self.id, :block.in => [true]).collect(&:user_id))
  end

  def new_join_requests
    User.where(:_id.in => (FriendRequest.where(:friend_id => self.id, :approve.in => [nil, false],:hold.in => [nil, false]).collect(&:user_id)))
  end

  def hidden_join_requests
    User.where(:_id.in => (FriendRequest.where(:friend_id => self.id, :approve.in => [nil, false],:hold.in => [true]).collect(&:user_id)))
  end

  def friend_requests_all_hide
    FriendRequest.where(:friend_id => self.id, :approve.in => [nil, false],:hold.in => [nil, false])
  end

   def friend_requests_all_delete
    FriendRequest.where(:friend_id => self.id, :approve.in => [nil, false],:hold.in => [true])
  end

  def followers
    User.where(:_id.in => FollowUser.where("following_id" => self.id).collect(&:user_id))
  end

  def following
    User.where(:_id.in => (FollowUser.where("user_id" => self.id).collect(&:following_id))).collect(&:_id)
  end

  def my_requests
    User.where(:_id.in => FriendRequest.where("user_id" => self.id).collect(&:user_id))
  end

  def require_approvals
    User.where(:_id.in => FriendRequest.where("friend_id" => self.id).collect(&:user_id))
  end

  def messages
     Message.where(:friend_id => self.id,:read.in => [nil, false]).collect(&:message)
  end

  def profile_image
   if self.profile_images.empty?
      "/img/default_profile_image.jpg"
   else
    self.profile_images.last.profile_image_url(:profile_image)
   end
  end

  def profile_image_thumb
   if self.profile_images.empty?
      "/img/default_profile_image_thumb_small.jpg"
   else
    self.profile_images.last.profile_image_url(:profile_image_thumb_small)
   end
  end

  def profile_image_thumb_small_chronicle
   if self.profile_images.empty?
      "/img/default_profile_image_thumb_small_chronicle.jpg"
   else
    self.profile_images.last.profile_image_url(:profile_image_thumb_small_chronicle)
   end
  end


  def banner_image
   if self.banner_images.empty?
      "/img/default_banner_image.jpg"
   else
    self.banner_images.last.banner_image_url(:banner_image)
   end
  end

  def set_verification_token
    self.verification_token = Time.now.to_i.to_s
  end

  def send_forgot_password
    self.verification_token = Time.now.to_i.to_s
    self.save(:validate => false)
    Notify.forgot_password_activation(self).deliver
  end

  def send_verification

     Notify.verify_registration(self).deliver

  end

  def send_verification_email
    self.connections.create(:category_type => "Friends")
    if self.email_changed?
      send_verification
    end
  end

  def to_indexed_json
        content = self.first_name + " " + self.last_name
        user_type = self.user_type.name unless self.user_type.nil?
        {
          :content => content,
          :display_name => self.display_name,
          :user_id => self.id,
          :verified => self.verified,
          :user_type =>  user_type
        }.to_json
    end

end
