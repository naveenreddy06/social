class DealImage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  belongs_to :feed

  field :dealimage
  mount_uploader :dealimage, DealImageUploader
end
