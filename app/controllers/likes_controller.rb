class LikesController < ApplicationController
  before_action :redirect_root, only: [:create, :destroy]

  def create
    @review = Review.find(params[:review_id])
    @like = current_user.likes.new(review_id: @review.id)
    @like.save!

    if @review.liked_by?(current_user)
      return if @review.user == current_user
      user = @review.user
      user.create_notification(@like)
    end
  end

  def destroy
    @review = Review.find(params[:review_id])
    @like = current_user.likes.find_by(review_id: @review.id)
    @like.destroy!
  end
end
