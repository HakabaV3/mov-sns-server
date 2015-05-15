module V1
  class Root < Grape::API
    version 'v1'
    
    mount V1::Sessions
    mount V1::Users
    mount V1::Groups
    mount V1::Invitations
    mount V1::Joins
    mount V1::Movies
    
  end
end