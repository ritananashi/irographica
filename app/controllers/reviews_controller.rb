class ReviewsController < ApplicationController
  def index
    @reviews = Review.includes(:user, :product).all
  end

  def show
    @review = Review.find_by(params[:id])
  end

  def new
    @review = Review.new
  end
end
