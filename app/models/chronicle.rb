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

    def to_indexed_json
        content = self.chronicle_title.to_s
        {
          :content => content,
          :chronicle_id => self.id,
          :permission  => self.permission,
          :user_info => self.user.first_name.to_s + " " + self.user.last_name.to_s + " " + self.user.display_name.to_s
        }.to_json
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
