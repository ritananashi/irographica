class RelationshipsController < ApplicationController
  before_action :redirect_root, only: [:create, :destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    if current_user.following?(@user)
      followed = current_user.active_relationships.find_by(followed_id: @user)
      @user.create_notification(followed)
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
