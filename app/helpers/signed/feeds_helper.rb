module Signed::FeedsHelper
  
  def feeds_acordion_hash
    {"Connections" => [], "Circles" => [], "Chronicles" => []}
  end
  
  def cool_status feed
    count =  UserFeed.where(:feed_id => feed.id, 'cool' => true).count
    count = (count == 0) ? " " : count
    ret = ''
    if current_user.user_feeds.where(:feed_id => feed.id, 'cool' => true).empty?
      img = image_tag "/img/relayimg/wow.png", :title => "WOW!"
      ret = link_to(img, feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"cool" => true}), :remote => true)
    else
      img = image_tag '/img/relayimg/wowed.png'
      ret = link_to(img, feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"cool" => false}), :remote => true)
    end
    content_tag(:span, ret + "  "+ count.to_s, :style => "font-size:12px;", :id => "#{feed.id.to_s}_cool", :ajax_call => true)
  end
  
  def favorite_status feed
    ret = ''
    count =  UserFeed.where(:feed_id => feed.id, 'favorite' => true).count
    count = (count == 0) ? " " : count
    if current_user.user_feeds.where(:feed_id => feed.id, 'favorite' => true).empty?
      img = image_tag "/img/relayimg/pin.png", :title => "pin"
      ret = link_to(img, feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"favorite" => true}), :remote => true)
    else
      img = image_tag '/img/relayimg/pinned.png'
      ret = link_to(img, feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"favorite" => false}), :remote => true)
    end
    content_tag(:span, ret.to_s + "  "+ count.to_s, :style => "font-size:12px;", :id => "#{feed.id.to_s}_favorite", :ajax_call => true)
  end
  
  def share_status feed
  end 
end
