class LikeRelationshipsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:like_id])
    current_user.like(micropost)
    flash[:success] = 'お気に入りリストに追加しました。'
    redirect_to root_url
  end

  def destroy
    micropost = Micropost.find(params[:like_id])
    current_user.unlike(micropost)
    flash[:success] = 'お気に入りリストを解除しました。'
    redirect_to root_url
  end
end
