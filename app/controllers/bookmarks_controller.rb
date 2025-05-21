class BookmarksController < ApplicationController
  before_action :redirect_root, only: [:create, :destroy]

  def create
    @review = Review.find(params[:review_id])
    current_user.bookmark(@review)

    if current_user.bookmarked_by?(@review)
      return if @review.user == current_user
      bookmark = current_user.bookmarks.find_by(review_id: @review.id)
      user = @review.user
      user.create_notification(bookmark)
    end
  end

  def destroy
    @review = current_user.bookmarks.find(params[:id]).review
    current_user.unbookmark(@review)
  end
end
