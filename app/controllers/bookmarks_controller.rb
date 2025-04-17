class BookmarksController < ApplicationController
  before_action :redirect_root, only: [:create, :destroy]

  def create
    review = Review.find(params[:review_id])
    current_user.bookmark(review)
    redirect_to request.referer, notice: "ブックマークしました"
  end

  def destroy
    review = current_user.bookmarks.find(params[:id]).review
    current_user.unbookmark(review)
    redirect_to request.referer, notice: "ブックマークを取り消しました", status: :see_other
  end
end
