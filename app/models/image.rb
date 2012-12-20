class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers
  belongs_to :user
  field :image
  mount_uploader :image, ImageUploader

end



