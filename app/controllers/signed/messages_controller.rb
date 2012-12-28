class Signed::MessagesController < Signed::BaseController

  before_filter :set_flashes_to_null, :check_authentication

  def create
     @msg = Message.create(params[:message])
     @message = Message.new
  end

  def index
  @messages = Message.desc("created_at").limit(20).where(:friend_id => current_user.id , :read.in => [nil,false])

   if params[:type] == "unlisted"
     @connections_list = User.where(:_id.in => UserFriend.where(:user_id => current_user.id, :connection_id => nil).collect(&:friend_id))

 @connection_messages = Message.where(:user_id.in => @connections_list.collect(&:id) ,:friend_id => current_user.id)

     elsif params[:type] == "connection"
  @connections_list = User.where(:_id.in => UserFriend.where(:connection_id => params[:id]).collect(&:friend_id))

   @connection_messages = Message.where(:user_id.in => @connections_list.collect(&:id) ,:friend_id => current_user.id)

   else
     @connections_list = current_user.my_friends
  end
 end

  def friend_message
    @message = Message.new
    messages = Message.where(:user_id => params[:id] ,:friend_id => current_user.id, :read.in => [nil, false])
    if messages
      messages.each do |msg|
        msg.update_attributes(:read => true)
      end
    end
    @allmessages = Message.desc("created_at").limit(8).where(:user_id.in => [params[:id], current_user.id] ,:friend_id.in => [params[:id], current_user.id]).entries
  end

  def fetch_older_messages
    @message = Message.new
    @allmessages = Message.desc("created_at").limit(8).where(:user_id.in => [params[:id], current_user.id] ,:friend_id.in => [params[:id], current_user.id], :created_at.lte => params[:last_message]).entries
  end

end
