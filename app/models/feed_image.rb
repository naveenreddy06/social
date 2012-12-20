class FeedImage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  belongs_to :feed

  field :feedimage
  mount_uploader :feedimage,FeedImageUploader
end
