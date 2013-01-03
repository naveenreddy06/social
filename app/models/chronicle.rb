class Chronicle
  include Mongoid::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks

  belongs_to :user

  has_many :user_chronicles, validate: false

  field :chronicle_title, :type => String
  field :published_date
  field :permission, :type => Boolean

  validates_length_of :chronicle_title, minimum: 1, maximum: 28
  validates :published_date, :presence => true

  after_save :set_public
  after_destroy :remove_user_chronicle

    mapping do
      indexes :id, type: 'string'
      indexes :user_id, type: 'string'
      indexes :chronicle_title, type: 'string'
      indexes :user_name
      indexes :permission, type: 'boolean'
    end

    def to_indexed_json
        to_json(methods: [:user_name])
    end

    def self.search(params)
      tire.search(page: params[:page], per_page: 10, load: true) do
        query do
          boolean do
            must { string params[:keyword], default_operator: "OR" } if params[:keyword].present?
            must {term :permission, true}
            must { term :chronicle_title, params[:name_filter] } if params[:name_filter].present?
            must { term :user_name, params[:user_filter] } if params[:user_filter].present?
          end
        end
      end
    end

    def user_name
    user.display_name.to_s + " " + user.first_name.to_s + " " +  user.last_name.to_s
    end

    def set_public
      if self.permission
        self.user.my_friends.each do |mf|
          self.user_chronicles.create(:user_id => mf.id)
        end
      else
        self.user_chronicles.each do |uc|
         uc.destroy
        end
      end
    end

    def remove_user_chronicle
      self.user_chronicles.each do |uc|
         uc.destroy
      end
    end

end
