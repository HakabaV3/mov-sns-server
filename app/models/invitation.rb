class Invitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :owner,  :class_name => 'User', :foreign_key => :owner_id
  belongs_to :target, :class_name => 'User', :foreign_key => :target_id
  
  accepts_nested_attributes_for :target
  accepts_nested_attributes_for :owner

  def self.search_by_group_name(group_name)
    return self.joins(:group).where(groups: {name: group_name})
  end
  
  def self.search_by_params(params)
    return self.joins(:group, :target).where(groups: {name: params[:group_name]}, users: {name: params[:user_name]}).first
  end
  
  # def owner_user
  #   return User.where(id: self.owner_id).first
  # end
  
  # def target_user
  #   return User.where(id: self.target_id).first
  # end
  
  def self.cancel(user)
    invitation = self.joins(:target).where(users: {name: user.name}).first
    return invitation.destroy
  end
  
end
