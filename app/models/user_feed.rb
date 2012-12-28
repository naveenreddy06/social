class UserFeed
  include Mongoid::Document
  belongs_to :user
  belongs_to :feed
  belongs_to :feed_type

  field :cool, :type => Boolean
  field :favorite, :type => Boolean
  field :hidden, :type => Boolean, :default => false
  field :shared, :type => Boolean, :default => false

  after_save :set_channels

  private

  def set_channels
    feed = self.feed
    if self.shared
      unless feed.channels.include? self.user_id.to_s
        feed.channels << self.user_id.to_s
        feed.save
      end
    else
      if self.feed.channels.include? self.user_id.to_s
        feed.channels.delete(self.user_id.to_s)
        feed.save
      end
    end
  end

end
