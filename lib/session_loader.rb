module SessionLoader

  def session_friends
    session[:myfds]=current_user.my_friends.collect{|usr| usr.id.to_s}
    session[:usr_self]=[current_user.id.to_s]
    session[:myfds].to_a + session[:usr_self].to_a 
  end

  def session_circles
    session[:usr_circles]=current_user.user_circles.collect{|cir| cir.circle_id.to_s}
    session[:circles]=current_user.circles.collect{|cir| cir.id.to_s}
    session[:usr_circles].to_a  + session[:circles].to_a 
  end

  def session_following
    session[:following]=current_user.following
    session[:following].to_a
  end

  def session_user_chronicles
    session[:otr_chronicles]=current_user.user_chronicles.collect{|chronicle| chronicle.chronicle_id.to_s}
    session[:usr_chronicles]=current_user.chronicles.collect{|chr| chr.id.to_s}
    session[:otr_chronicles].to_a  + session[:usr_chronicles].to_a 
  end

  def session_connections
    session[:fds_connections]=UserFriend.where("friend_id" => current_user.id).collect(&:connection_id)
    session[:usr_connections]=current_user.connections.collect{|conn| conn.id.to_s}
    session[:fds_connections].to_a  + session[:usr_connections].to_a 
  end

  def set_all
    session_friends
    session_circles
    session_following
    session_user_chronicles
    session_connections
  end

  def session_all
    session_friends + session_circles + session_following + session_user_chronicles + session_connections
  end

end
