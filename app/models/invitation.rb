class Invitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :owner,  :class_name => 'User', :foreign_key => :id
  belongs_to :target, :class_name => 'User', :foreign_key => :id
  
  def self.search_by_group_name(group_name)
    return Invitation.join(:group).where(groups: {name: group_name})
  end
  
end
