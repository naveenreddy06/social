module Signed::FeedsHelper
  
  def feeds_acordion_hash
    {"Connections" => [], "Circles" => [], "Chronicles" => []}
  end
  
  def cool_status feed
    count =  UserFeed.where(:feed_id => feed.id, 'cool' => true).count
    count = (count == 0) ? " " : count
    ret = ''
    if current_user.user_feeds.where(:feed_id => feed.id, 'cool' => true).empty?
      img = image_tag "/img/coolpinshare/wow.png", :title => "WOW!"
      ret = link_to(img + " " + "wow!", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"cool" => true}), :remote => true)
    else
      img = image_tag '/img/coolpinshare/wow.png'
      ret = link_to(img + " " + "unwow", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"cool" => false}), :remote => true)
    end
    content_tag(:span, ret + "  "+ count.to_s, :style => "font-size:12px;", :id => "#{feed.id.to_s}_cool", :ajax_call => true)
  end
  
  def favorite_status feed
    ret = ''
    count =  UserFeed.where(:feed_id => feed.id, 'favorite' => true).count
    count = (count == 0) ? " " : count
    if current_user.user_feeds.where(:feed_id => feed.id, 'favorite' => true).empty?
      img = image_tag "/img/coolpinshare/pin.png", :title => "pin"
      ret = link_to(img + " " + "pin it!", "#", "data-toggle" => "modal", "data-target" => "#myemotionsModal", :onclick => "emotionId = '#{feed.id.to_s}'")
    else
      img = image_tag '/img/coolpinshare/pin.png'
     ret = link_to(img + " " + "unpin", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"favorite" => false}), :remote => true)
    end
    content_tag(:span, ret.to_s + "  "+ count.to_s, :style => "font-size:12px;", :id => "#{feed.id.to_s}_favorite", :ajax_call => true)
  end
  
  def shared_status feed
    ret = ''
    count =  UserFeed.where(:feed_id => feed.id, 'shared' => true).count
    count = (count == 0) ? " " : count
    if feed.user == current_user and feed.public
      ret = (image_tag "/img/coolpinshare/share.png") + " " + "share"
    elsif feed.public and count.to_i< 1000
      if current_user.user_feeds.where(:feed_id => feed.id, 'shared' => true).empty?
        img = image_tag "/img/coolpinshare/share.png", :title => "share"
        ret = link_to(img + " " + "share all", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"shared" => true}), :remote => true) 
      else
        img = image_tag "/img/coolpinshare/share.png"
        ret = link_to(img + " " + "unshare", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"shared" => false}), :remote => true)
      end
    end
    content_tag(:span, ret.to_s + "  "+ count.to_s, :style => "font-size:12px;", :id => "#{feed.id.to_s}_shared", :ajax_call => true)
  end 
end
