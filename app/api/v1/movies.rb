module V1
  class Movies < Grape::API
    namespace 'groups/:group_id/movies' do
      
      # GET /api/v1/groups/:group_id/movies
      params do
        requires :group_id, type: Integer
      end
      get '', jbuilder: 'movies/index' do
        authenticated(heders)
        error!("該当グループの動画を閲覧できません。") unless current_user.joined?(params[:group_id])
        
        @movies = Movie.where(group_id: params[:group_id])
        error!("該当グループには動画はありません。") unless @movies.present?
      end
      
      # GET /api/v1/groups/:group_id/movies/:movie_id
      params do
        requires :group_id, type: Integer
        requires :movie_id, type: Integer
      end
      get ':movie_id', jbuilder: 'movies/new' do
        authenticated(heders)
        error!("該当グループの動画を閲覧できません。") unless current_user.joined?(params[:group_id])
        
        @movie = Movie.where(id: params[:movie_id])
        error!("該当する動画の取得に失敗しました。") unless @movie.present?
      end
      
      # POST /api/v1/groups/:group_id/movies
      params do
        requires :group_id,    type: Integer
        requires :name,        type: String
        requires :description, type: String
        requires :path,        type: String
      end
      post '', jbuilder: 'movies/new' do
        authenticated(headers)
        error!("該当グループに動画を投稿できません。") unless current_user.joined?(params[:group_id])
        
        @movie = Movie.new(user_id: current_user.id,
                           group_id: params[:group_id],
                           name: params[:name],
                           description: params[:description],
                           path: params[:path])
        error!("動画の作成に失敗しました。") unless @movie.save
      end
      
      # PATCH /api/v1/groups/:group_id/movies/:movie_id
      params do
        requires :group_id,    type: Integer
        requires :movie_id,    type: Integer
        optional :name,        type: String
        optional :description, type: String
        optional :path,        type: String
      end      
      patch ':movie_id', jbuilder: 'movies/new' do
        authenticated(headers)
        error!("該当グループの動画を編集できません。") unless current_user.joined?(params[:group_id])
        
        @movie = Movie.where(id: params[:movie_id]).first
        error!("該当動画の編集に失敗しました。") unless @movie.update_data(params[:name], params[:description], params[:path])
      end
      
      # DELETE /api/v1/groups/:group_id/movies/:movie_id
      params do
        requires :group_id, type: Integer
        requires :movie_id, type: Integer
      end
      delete ':movie_id' do
        authenticated(headers)
        @movie = Movie.where(id: params[:movie_id]).first
        if !current_user.joined?(params[:group_id]) && @movie.user.id != current_user.id
          error!("該当の動画を削除できません。")
        end
        @movie.destroy
        status 200
      end
      
    end
  end
end