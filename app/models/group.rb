class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users,       :through => :user_groups
  has_many :invitations, :dependent => :destroy
  has_many :movies,      :dependent => :destroy
  
  belongs_to :owner, :class_name => 'User', :foreign_key => :id
  
  accepts_nested_attributes_for :users
  
  def self.search_by_name(name)
    return Group.where(name: name).first
  end

  def self.available?(params)
    if Group.where(name: params[:group_name]).count > 0
      return false
    end
    return true
  end
  
#  def owner
#    return User.where(id: self.owner_id).first
#  end
  
end
