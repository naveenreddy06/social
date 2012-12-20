class EventImage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  belongs_to :feed

  field :eventimage
  mount_uploader :eventimage,EventImageUploader
end
