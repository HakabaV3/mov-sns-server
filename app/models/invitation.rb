class Invitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :owner,  :class_name => 'User', :foreign_key => :id
  belongs_to :target, :class_name => 'User', :foreign_key => :id
end
