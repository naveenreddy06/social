class UserFeed
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  belongs_to :feed
  belongs_to :feed_type

  field :cool, :type => Boolean
  field :favorite, :type => Boolean
  field :hidden, :type => Boolean, :default => false
  field :shared, :type => Boolean, :default => false

  before_save :set_channels

  private

  def set_channels
    feed = self.feed
    if self.shared
      unless feed.channels.include? self.user_id.to_s
        feed.channels << self.user_id.to_s
        feed.save
      end
    elsif self.shared_changed? and feed.channels.include? self.user_id.to_s and (self.user_id != self.feed.user_id)
      feed.channels.delete(self.user_id.to_s)
      feed.save
    end
  end

end
