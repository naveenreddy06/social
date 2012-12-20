class BannerImage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  belongs_to :user
  field :banner_image
  mount_uploader :banner_image, BannerImageUploader
end


