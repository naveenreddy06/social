class CircleProfileImage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  belongs_to :circle
  field :circle_profile_image
  mount_uploader :circle_profile_image, CircleProfileImageUploader
end
