class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :user_groups
  has_many :groups,      :through => :user_groups
  has_many :sessions,    :dependent => :destroy
  has_many :movies,      :dependent => :destroy
  has_many :invited,     :class_name => "Invitation", :foreign_key => 'target_id', :dependent => :destroy
  has_many :inviting,    :class_name => "Invitation", :foreign_key => 'owner_id',  :dependent => :destroy
  has_many :owns_groups, :class_name => 'Group',      :foreign_key => 'owner_id'
  
  validates :name, presence: true
  
  def update_data(email, password, name)
    self.email = email unless email.nil?
    self.password = passowrd unless password.nil? 
    self.name = name.presence unless name.nil?
    retuen self.save
  end
  
  def token
    return self.sessions.pluck(:token).first
  end
  
  def join_group(group_id)
    group = Group.where(id: group_id).first
    group.users << self
    return group.save
  end
  
  def leave_group(group_id)
    return self.groups.destroy(Group.where(id: group_id).first)
  end
  
  def joined?(group_id)
    return self.groups.where(id: group_id).first.present?
  end
  
  def has_invited?(group_id)
    return self.invited.where(group_id: group_id).first.present?
  end
  
end
