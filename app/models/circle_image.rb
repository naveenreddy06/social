class CircleImage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  belongs_to :circle
  field :circle_image
  mount_uploader :circle_image, CircleImageUploader
end
