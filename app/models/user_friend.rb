class UserFriend
  include Mongoid::Document
  belongs_to :user

  field :friend_id, :type => String
  field :block, :type => Boolean
  field :connection_id

  def connection
    conn = Connection.where("_id" => self.connection_id).first
    conn ? conn.category_title : ""
  end


end
