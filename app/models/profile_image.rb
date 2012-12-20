class ProfileImage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers
  belongs_to :user
  field :profile_image
  mount_uploader :profile_image, ProfileImageUploader
end









