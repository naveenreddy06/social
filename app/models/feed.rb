class Feed
  include Mongoid::Document
  include Mongoid::Timestamps

  include Tire::Model::Search
  include Tire::Model::Callbacks

    has_one :feed_image, validate: false, :dependent => :destroy
    has_one :deal_image, validate: false, :dependent => :destroy
    has_one :event_image, validate: false, :dependent => :destroy
    accepts_nested_attributes_for :deal_image
    accepts_nested_attributes_for :feed_image
    accepts_nested_attributes_for :event_image
    has_many :user_feeds, validate: false, :dependent => :destroy

    embeds_many :comments
    belongs_to :user
    belongs_to :feed_type


    field :feed
    field :tag_user
    field :add_link
    field :public, type: Boolean
    field :feed_hash, type: Hash
    field :channels, type: Array
    field :tags, type: Array
    
    after_create :set_feed_array, :set_tags_array
    validates :feed, :presence => true, :on => :create

    def to_indexed_json
        content = self.feed.to_s
        {
          :content => content,
          :feed_id => self.id,
          :public => self.public,
          :user => self.user.id,
          :feed_type_id => self.feed_type_id,
          :channels => self.channels.to_a.collect{|c| c}.join(" ")
        }.to_json
    end

    def set_feed_array
      if !self.channels.nil?
        self.public = false
      else
        self.channels = []
        self.channels << self.user.id.to_s
      end
      self.save
    end

  def feed_images
       self.feed_image.feedimage_url(:feedimage)
  end

  def feed_zooms
       self.feed_image.feedimage_url(:feedzoom)
  end

  def event_images
       self.event_image.eventimage_url(:eventimage)
  end

  def deal_images
       self.deal_image.dealimage_url(:dealimage)
  end

   def set_tags_array
     unless self.tag_user.nil?
       self.tags = self.tag_user.split(",").uniq
       self.save
     end
   end


end




