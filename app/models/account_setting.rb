class AccountSetting
  include Mongoid::Document

  embedded_in :user


  field :user_type, :type => String
  field :about_me, :type => String

  #field :user_type, :type => String
  #field :about_me, :type => String
  field :address, :type => String

  field :country_name, :type => String
  field :state_name, :type => String
  field :city, :type => String
  field :postal_code, :type => String

  #field :address, :type => String





end
