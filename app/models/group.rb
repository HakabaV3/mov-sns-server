class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users,       :through => :user_groups
  has_many :invitations, :dependent => :destroy
  has_many :movies,      :dependent => :destroy
  
  belongs_to :owner,     :class_name => 'User',   :foreign_key => :id
  
  accepts_nested_attributes_for :users
  
end
