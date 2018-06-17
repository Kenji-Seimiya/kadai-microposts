class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.add_likes(micropost)
    flash[:success] = 'likesしました。'
    redirect_to :back
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.rem_likes(micropost)
    flash[:success] = 'likesを解除しました。'
    redirect_to :back
  end
end
