module ApiHelper

  # Create Factory Girl Model
  
  def create_token
    @current_user = create(:user)
    @token = create(:session, user_id: @current_user.id).token
  end
  
  def create_group
    create_token
    @group = create(:group)
    @owner_token = create(:session, user_id: @group.owner_id).token
  end
  
  def create_invitation
    create_token
    @invitation = create(:invitation)
    @owner_token = create(:session, user_id: @invitation.owner_id).token
    @target_token = create(:session, user_id: @invitation.target_id).token

    @group = @invitation.group
    @joined_user = create(:user)
    @group.users << @joined_user
    @group.save
    @joined_token = create(:session, user_id: @joined_user.id).token
  end
  
  # Common JSON
  
  def json_common
    {
      status: String,
      result: Hash
    }
  end
  
  def json_error
    {
      code: Fixnum,
      type: String,
      detail: Hash
    }
  end
  
  # Sessions
  
  def json_session(session)
    {
      id: session["id"],
      created: wildcard_matcher,
      updated: wildcard_matcher,
      user: Hash,
      token: session["token"]
    }
  end
  
  # Users
  
  def json_users
    {
      users: Array    
    }
  end
  
  def json_user(user)
    {
      id: user["id"],
      name: user["name"],
      emali: user["email"]
    }
  end
  
  # Invitaitons
  
  def json_invitaitons
    {
      invitations: Array
    }
  end
  
  def json_invitation(invitation)
    {
      id: invitation["id"],
      created: invitation["created"],
      updated: invitation["updated"],
      target: Hash,
      owner: Hash
    }
  end
  
  # Join
  
  
  
end