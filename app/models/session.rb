class Session < ActiveRecord::Base
  belongs_to :user
  
  def self.create_session(user)
    self.destroy_session(user)
    self.create(user_id: user.id, token: "#{Devise.friendly_token}_#{user.id}")
  end
  
  def self.destroy_session(user)
    self.destroy(user.sessions.pluck(:id))
  end
  
end
