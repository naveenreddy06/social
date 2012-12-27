module Signed::FeedsHelper
  
  def feeds_acordion_hash
    {"Connections" => [], "Circles" => [], "Chronicles" => []}
  end
  
  def cool_status feed
    ret = ''
    if current_user.user_feeds.where(:feed_id => feed.id, 'cool' => true).empty?
      img = image_tag "/img/relayimg/wow.png", :title => "WOW!"
      ret = link_to(img, feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"cool" => true}), :remote => true)
    else
      img = image_tag '/img/relayimg/wowed.png'
      ret = link_to(img, feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"cool" => false}), :remote => true)
    end
    content_tag(:span, ret, :class => "span6", :id => "#{feed.id.to_s}_cool", :ajax_call => true)
  end
  
  def pin_status feed
  end
  
  def share_status feed
  end 
end
