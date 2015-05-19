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

  def self.is_used(params)
    detail = {}
    if params[:email].present?
      detail[:email] = params[:email] if User.where(email: params[:email]).count > 0
    end
    if params[:name].present?
      detail[:name] = params[:name] if User.where(name: params[:name]).count > 0 
    end
    return detail
  end
  
  def update_data!(params)
    self.email = params[:email] unless params[:email].nil?
    self.password = params[:password] unless params[:password].nil? 
    self.name = params[:name] unless params[:name].nil?
    return self.save
  end
    
end
