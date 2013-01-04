class Circle
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tire::Model::Search
  include Tire::Model::Callbacks

  #Start Associations --------------------------------------------------

     belongs_to :user
     has_many :user_circles, validate: false
     has_many :circle_details
     accepts_nested_attributes_for :circle_details, :allow_destroy => true
     has_many :circle_images, validate: false
     accepts_nested_attributes_for :circle_images, :reject_if => proc { |attributes| attributes['circle_image'].blank? }
     has_many :circle_profile_images, validate: false
     accepts_nested_attributes_for :circle_profile_images, :reject_if => proc { |attributes| attributes['circle_profile_image'].blank? }

  #End Associations ----------------------------------------------------

  #Start attributes for circle form ------------------------------------

    field :name , :type => String
    field :listed, :type => Boolean
    field :approve, :type => Boolean
    field :short_description,  :type => String
    field :keyword_tags,  :type => String
    field :hidden, :type => Boolean, :default => false

  #End attributes for circle form --------------------------------------

  #Start validations --------------------------------------------------

    validates_length_of :name, minimum: 1, maximum: 28

  #End validations -----------------------------------------------------

  #Start Callbacks -----------------------------------------------------

    after_create :set_user_admin

  #End Callbacks -------------------------------------------------------


  def circle_profile_image_left
   if self.circle_profile_images.empty?
      "/img/default_profile_image_thumb_small.jpg"
   else
    self.circle_profile_images.last.circle_profile_image_url(:circle_profile_image_left)
   end
  end

  def circle_profile_image_min_thumb
   if self.circle_profile_images.empty?
      "/img/default_profile_image_thumb_small.jpg"
   else
    self.circle_profile_images.last.circle_profile_image_url(:circle_profile_image_mini_thumb)
   end
  end

  def circle_profile_image_thumb
   if self.circle_profile_images.empty?
      "/img/default_profile_image_thumb_small.jpg"
   else
    self.circle_profile_images.last.circle_profile_image_url(:circle_profile_image_thumb)
   end
  end


  def circle_profile_image
   if self.circle_profile_images.empty?
      "/img/default_banner_image.jpg"
   else
    self.circle_profile_images.last.circle_profile_image_url(:circle_profile_image)
   end
  end

  def circle_image
   if self.circle_images.empty?
      "/img/default_banner_image.jpg"
   else
    self.circle_images.last.circle_image_url(:circle_image)
   end
  end

  mapping do
      indexes :id, type: 'string'
      indexes :user_id, type: 'string'
      indexes :name, type: 'string'
      indexes :user_name
      indexes :hidden, type: 'boolean'
      indexes :listed, type: 'boolean'
      indexes :keyword_tags, type: 'string'
      indexes :short_description, type: 'string'
    end

    def to_indexed_json
        to_json(methods: [:user_name])
    end

    def self.search(params)
      tire.search(page: params[:page], per_page: 10, load: true) do
        query do
          boolean do
            must { string params[:keyword], default_operator: "OR" } if params[:keyword].present?
            must { term :listed, true }
            must { term :name, params[:name_filter] } if params[:name_filter].present?
            must { term :keyword_tags, params[:keyword_filter] } if params[:keyword_filter].present?
          end
        end
      end
    end

    def user_name
    user.display_name.to_s + " " + user.first_name.to_s + " " +  user.last_name.to_s
    end

  private

  def set_user_admin
    self.user_circles.create(:user_id => self.user_id, :approve => false, :admin => true)
  end




end
