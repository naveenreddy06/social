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

    mapping do
      indexes :id, type: 'string'
      indexes :user_id, type: 'string'
      indexes :feed_type_id, type: 'string'
      indexes :feed
      indexes :user_name
      indexes :add_link
      indexes :current_channels, type: 'string'
      indexes :public, type: 'boolean'
    end

    def to_indexed_json
        to_json(methods: [:user_name, :current_channels])
    end

    def self.search(params)
      tire.search(page: params[:page], per_page: 10, load: true) do
        query do
          boolean do
            must { string params[:keyword], default_operator: "OR" } if params[:keyword].present?
            must { term :public, true } unless params[:channels].present?
            should { string "public: true OR current_channels: #{params[:channels]}" } if params[:channels].present?
            must { term :feed_type_id, params[:filter] } if params[:filter].present?
          end
        end
      end
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

  def user_name
    user.display_name.to_s + " " + user.first_name.to_s + " " +  user.last_name.to_s
  end

  def current_channels
    channels.collect{|c| c}.join(" ")
  end


end




