class Signed::MessagesController < Signed::BaseController
  
  before_filter :set_flashes_to_null, :check_authentication
  
  def create
     @msg = Message.create(params[:message])
     @message = Message.new
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
